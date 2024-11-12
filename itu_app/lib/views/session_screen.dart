// session_screen.dart
import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../controllers/job_controller.dart';
import '../controllers/template_controller.dart';
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
  late SessionController _sessionController;
  late JobController _jobController;
  late TemplateController _templateController;
  List<WorkSession> _sessions = [];
  List<WorkSession> _templates = [];

  @override
  void initState() {
    super.initState();
    _sessionController = SessionController(HiveService());
    _jobController = JobController(HiveService());
    _templateController = TemplateController(HiveService());
    loadSessions();
  }

  void loadSessions() {
    setState(() {
      _sessions = _sessionController.getSessionsForJob(widget.jobId);
      _templates = _templateController.getTemplatesForJob(widget.jobId);
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
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
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
                        },
                        background: Container(
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
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _templates.length +
                  1, // Always include the "Add workday" button as the last item
              itemBuilder: (BuildContext context, int index) {
                return index == _templates.length
                    ?
                    // Add workday button at the bottom of the templates list
                    _buildNewTemplateButton(context)
                    :
                    // Template item
                    _buildTemplateButton(index);
              },
            ),
          ),
          const SizedBox(height: 30.0), // Additional spacing below the button
        ],
      ),
    );
  }

  Padding _buildTemplateButton(int index) {
    WorkSession template = _templates[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 375, maxHeight: 72),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white, // White background
            borderRadius: BorderRadius.circular(60), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2), // Subtle shadow for depth
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${template.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _pickDate(context, template.templateId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0x91D4FFFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    child: Text(
                      DateFormat("EEE, d.m.").format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Fixed spacing between buttons
                  ElevatedButton(
                    onPressed: () {
                      _sessionController.addWorkSession(
                        widget.jobId,
                        templateId: index,
                      );
                      loadSessions(); // Reload sessions after adding from template
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0x91D4FFFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    child: const Text(
                      'Add Shift',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildNewTemplateButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 375, maxHeight: 72),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddSessionScreen(job: widget.job),
              ),
            ).then((_) => loadSessions());
          },
          label:
              const Text('Add template', style: TextStyle(color: Colors.black)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 138, vertical: 25),
            backgroundColor: Colors.white, // White button background
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, int templateId) async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      _sessionController.addWorkSession(widget.jobId,
          templateId: templateId, date: newDate);
      loadSessions();
    }
  }
}
