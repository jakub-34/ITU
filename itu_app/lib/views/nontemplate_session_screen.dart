// Author: Jakub Hrdlička
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../controllers/job_controller.dart';
import '../controllers/session_controller.dart';
import '../models/job.dart';
import '../models/work_session.dart';
import '../services/hive_service.dart';
import 'add_nontemplate_session.dart';

class NonTemplateSessionScreen extends StatefulWidget {
  final int jobId;
  final String jobTitle;
  final Job job;

  const NonTemplateSessionScreen({
    super.key,
    required this.jobId,
    required this.jobTitle,
    required this.job,
  });

  @override
  _NonTemplateSessionScreenState createState() =>
      _NonTemplateSessionScreenState();
}

class _NonTemplateSessionScreenState extends State<NonTemplateSessionScreen> {
  late SessionController _sessionController;
  late JobController _jobController;
  List<WorkSession> _sessions = [];

  @override
  void initState() {
    super.initState();
    _sessionController = SessionController(HiveService());
    _jobController = JobController(HiveService());
    loadSessions();
  }

  void loadSessions() {
    setState(() {
      _sessions = _sessionController.getSessionsForJob(widget.jobId);
    });
  }

  Future<void> _deleteConfirmDialog() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm delete'),
            content: const Text('Are you sure you want to delete this job?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.black))),
              ElevatedButton(
                  onPressed: () => {
                        _jobController.deleteJob(widget.jobId),
                        Navigator.pop(context),
                        Navigator.pop(context)
                      },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Delete',
                      style: TextStyle(color: Colors.black)))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: [
          // Custom Header with Job Title Bubble and Delete Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Job Title Bubble
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    shadowColor: Colors.black.withOpacity(0.1),
                    elevation: 4, // This creates the shadow effect
                  ),
                  child: Text(
                    widget.jobTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                // Delete Button
                ElevatedButton(
                  onPressed: () {
                    _deleteConfirmDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: _sessions.isNotEmpty
                ? ListView.builder(
                    itemCount: _sessions.length,
                    itemBuilder: (context, index) {
                      WorkSession session = _sessions[index];
                      return Dismissible(
                        key: Key(
                            '${session.jobId}-${session.sessionId}'), // Unique key combining jobId and sessionId
                        direction: DismissDirection
                            .horizontal, // Allow both swipe directions
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            // Handle left swipe to delete
                            // Store session temporarily
                            WorkSession deletedSession = session;
                            int deletedIndex = index;
                            await _sessionController.deleteSession(session);
                            setState(() {
                              _sessions.removeAt(
                                  index); // Remove session from the list
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: const Text('Session deleted'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      // Re-add deleted session
                                      setState(() {
                                        _sessions.insert(
                                            deletedIndex, deletedSession);
                                      });
                                      _sessionController
                                          .addWorkSessionFromSession(
                                              deletedSession);
                                    },
                                  )),
                            );
                            return true; // Return true to confirm the dismissal
                          } else if (direction == DismissDirection.startToEnd) {
                            // Handle right swipe to create a new session
                            var newSession = WorkSession(
                              sessionId: _sessionController.hiveService
                                  .getNewSessionId(),
                              jobId: session.jobId,
                              date: DateTime.now(), // Use today's date
                              startTime: session.startTime,
                              endTime: session.endTime,
                            );
                            _sessionController
                                .addWorkSessionFromSession(newSession);
                            // Reload sessions to immediately reflect the new session
                            loadSessions();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('New session created for today')),
                            );
                            return false; // Return false to prevent the widget from being dismissed
                          }
                          return false; // By default, don't dismiss
                        },
                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.green,
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                                maxWidth: 410, maxHeight: 72),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              decoration: BoxDecoration(
                                color: Colors.white, // White background
                                borderRadius: BorderRadius.circular(
                                    60), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(
                                        0, 2), // Subtle shadow for depth
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${session.date.day}.${session.date.month}.${session.date.year}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${DateFormat('HH:mm').format(session.startTime)} - ${DateFormat('HH:mm').format(session.endTime)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No sessions added yet.',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 20), // Space between content and divider
            child: Divider(thickness: 4, color: Colors.grey[300]),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20.0), // Align Total and button consistently
          ),

          // Add New Session button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380, maxHeight: 75),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddNonTemplateSession(job: widget.job),
                    ),
                  ).then(
                      (_) => loadSessions()); // Reload jobs after adding a job
                },
                label: const Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Add workday',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(500, 150),
                  backgroundColor: Colors.white, // White button background
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30.0), // Additional spacing below the button
        ],
      ),
    );
  }
}
