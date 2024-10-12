import 'package:flutter/material.dart';
import '../controllers/job_controller.dart';
import '../models/job.dart';
import '../models/work_session.dart';
import '../services/hive_service.dart';
import 'add_job_screen.dart';
import 'add_session_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final JobController jobController = JobController(HiveService());
  List<Job> jobs = [];

  @override
  void initState() {
    super.initState();
    loadJobs(); // Load jobs when the state is initialized
  }

  void loadJobs() async {
    await HiveService().init(); // Make sure Hive is initialized
    setState(() {
      jobs = jobController.getAllJobs(); // Load jobs
      print("loading jobssss");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Part-Time Job Tracker')),
      body: Column(
        children: [
          // Only display earnings if there are jobs
          if (jobs.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total Earnings This Month: \$${jobController.getMonthlyEarnings().toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          Expanded(
            child: jobs.isNotEmpty 
              ? ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    // Calculate and display hours worked and earnings
                    List<WorkSession> sessions = jobController.getSessionsForJob(jobs[index].id!);
                    double totalHoursWorked = sessions.fold(0.0, (sum, session) {
                      if (session.date.month == DateTime.now().month &&
                          session.date.year == DateTime.now().year) {
                        return sum + session.hoursWorked;
                      }
                      return sum;
                    });
                    double totalEarnings = sessions.fold(0.0, (sum, session) {
                      if (session.date.month == DateTime.now().month &&
                          session.date.year == DateTime.now().year) {
                        return sum + (session.hoursWorked * jobs[index].hourlyRate) + session.extraPay;
                      }
                      return sum;
                    });

                    return ListTile(
                      title: Text(jobs[index].title),
                      subtitle: Text('Hourly Rate: \$${jobs[index].hourlyRate}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Hours Worked This Month: ${totalHoursWorked.toStringAsFixed(2)}'),
                          Text('Earnings: \$${totalEarnings.toStringAsFixed(2)}'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddSessionScreen(job: jobs[index]),
                          ),
                        ).then((_) => loadJobs()); // Reload jobs after adding session
                      },
                    );
                  },
                )
              : Center(child: Text('No jobs added yet. Please add a job to start tracking earnings.')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddJobScreen(jobController: jobController),
            ),
          ).then((_) =>   loadJobs()); // Reload jobs after adding a job
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
