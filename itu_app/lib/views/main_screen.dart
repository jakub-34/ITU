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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Grey background color
      body: Column(
        children: [
          if (jobs.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
            ),
          ],
          Expanded(
            child: jobs.isNotEmpty
                ? ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      List<WorkSession> sessions =
                          jobController.getSessionsForJob(jobs[index].id);

                      return ListTile(
                        title: Text(jobs[index].title),
                        subtitle:
                            Text('Hourly Rate: \$${jobs[index].hourlyRate}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                'Hours Worked This Month: ${jobController.getMonthlyHoursForJob(jobs[index])}'),
                            Text(
                                'Earnings: ${jobController.getMonthlyEarningsForJob(jobs[index])}€'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddSessionScreen(job: jobs[index]),
                            ),
                          ).then((_) =>
                              loadJobs()); // Reload jobs after adding session
                        },
                      );
                    },
                  )
                : const Center(
                    child: Text('No jobs added yet.',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
          ),

          // Bottom
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 20), // Space between content and divider
            child: Divider(thickness: 4, color: Colors.grey[300]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0), // Align Total and button consistently
            child: Column(
              children: [
                // Total Section styled like the button
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 375, maxHeight: 72),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 120, vertical: 25),
                    decoration: BoxDecoration(
                      color: Colors.white, // White background
                      borderRadius: BorderRadius.circular(
                          60), // Rounded corners like button
                    ),
                    child: Center(
                      child: Text(
                        'Total: ${jobController.getMonthlyEarnings().toStringAsFixed(2)}€',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    height: 30), // Spacing between "Total" and button
                // Add New Job button
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 500, maxHeight: 150),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddJobScreen(jobController: jobController),
                        ),
                      ).then(
                          (_) => loadJobs()); // Reload jobs after adding a job
                    },
                    icon: const Icon(Icons.add, color: Colors.black),
                    label: const Text('Add new job',
                        style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 120, vertical: 25),
                      backgroundColor: Colors.white, // White button background
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30.0), // Additional spacing below the button
        ],
      ),
    );
  }
}
