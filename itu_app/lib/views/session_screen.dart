// session_screen.dart
import 'package:flutter/material.dart';
import '../controllers/session_controller.dart';
import '../models/job.dart';
import '../models/work_session.dart';
import '../services/hive_service.dart';
import 'add_session_screen.dart';

class SessionScreen extends StatefulWidget {
  final int jobId;
  final String jobTitle;
  final Job job;

  const SessionScreen({
    super.key,
    required this.jobId,
    required this.jobTitle,
    required this.job,
  });

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  late SessionController sessionController;
  List<WorkSession> sessions = [];

  @override
  void initState() {
    super.initState();
    sessionController = SessionController(HiveService());
    loadSessions();
  }

  void loadSessions() {
    setState(() {
      sessions = sessionController.getSessionsForJob(widget.jobId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jobTitle),
      ),
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: [
          Expanded(
            child: sessions.isNotEmpty
                ? ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                WorkSession session = sessions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${session.date.day}.${session.date.month}.${session.date.year}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              '${session.date.hour}:${session.date.minute} - ${session.hoursWorked.toStringAsFixed(2)}h',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                        Text(
                          '+ ${session.extraPay.toStringAsFixed(2)}€',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
                : const Center(
              child: Text(
                'No sessions added yet.',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
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
                              AddSessionScreen(job: widget.job),
                        ),
                      ).then(
                              (_) => loadSessions()); // Reload jobs after adding a job
                    },
                    label: const Text('Add workday',
                        style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 138, vertical: 25),
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
