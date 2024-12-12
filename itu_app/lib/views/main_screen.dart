// Authors: Jakub Hrdlička, Tomáš Žgút
import 'package:flutter/material.dart';
import '../controllers/job_controller.dart';
import '../models/job.dart';
import '../services/hive_service.dart';
import 'session_screen.dart';
import 'add_job_screen.dart';
import 'nontemplate_session_screen.dart';

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

  // Author: Jakub Hrdlička
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Grey background color
      body: Column(
        children: [
          if (jobs.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
            ),
          ],
          Expanded(
            child: jobs.isNotEmpty
                ? ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              maxWidth: 375, maxHeight: 72),
                          child: ElevatedButton(
                            onPressed: () {
                              // Check the useTemplates property to decide which screen to navigate to
                              if (jobs[index].usesTepmates) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SessionScreen(
                                      jobId: jobs[index].id,
                                      jobTitle: jobs[index].title,
                                      job: jobs[index],
                                    ),
                                  ),
                                ).then((_) => loadJobs());
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NonTemplateSessionScreen(
                                      jobId: jobs[index].id,
                                      jobTitle: jobs[index].title,
                                      job: jobs[index],
                                    ),
                                  ),
                                ).then((_) => loadJobs());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              backgroundColor: Colors.white, // White background
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    60), // Rounded corners
                              ),
                              shadowColor: Colors.black
                                  .withOpacity(0.1), // Shadow for depth
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      jobs[index].title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${jobController.getMonthlyHoursForJob(jobs[index]).toStringAsFixed(1)}h / ${jobController.getMonthlyEarningsForJob(jobs[index]).toStringAsFixed(2)}€',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 20), // Space between content and divider
            child: Divider(thickness: 4, color: Colors.grey[300]),
          ),
          // End of Jakub's code

          // Author: Tomáš Žgút
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0), // Align Total and button consistently
            child: Column(
              children: [
                // Total Section styled like the button
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380, maxHeight: 75),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Center(
                      child: Text(
                        'Total: ${jobController.getMonthlyEarnings().toStringAsFixed(2)}€',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                // Add New Job button
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380, maxHeight: 75),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddJobScreen(jobController: jobController),
                        ),
                      ).then((_) => loadJobs()); // Reload jobs after adding a job
                    },
                    label: const Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Add new job',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(500, 150),
                      backgroundColor: Colors.white, // White button background
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      padding: EdgeInsets.zero,
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
