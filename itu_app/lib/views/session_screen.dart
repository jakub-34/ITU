// session_screen.dart
import 'package:flutter/material.dart';
import '../controllers/session_controller.dart';
import '../models/work_session.dart';
import '../services/hive_service.dart';

class SessionScreen extends StatefulWidget {
  final int jobId;
  final String jobTitle;

  const SessionScreen({super.key, required this.jobId, required this.jobTitle});

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

  Future<void> _addNewSession() async {
    // Implement a method to add a new session
    // For example, you could navigate to a form screen to get session data
    // or show a dialog to enter session details.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jobTitle),
        backgroundColor: const Color(0xFF121212),
      ),
      backgroundColor: const Color(0xFF121212), // Grey background color
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
                          offset: Offset(0, 2),
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
                    fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _addNewSession,
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text('Add Workday',
                  style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                backgroundColor: Colors.white,
                textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
