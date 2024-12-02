// author: Jakub Hrdlička
// author: Tomáš Zgút
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import '../controllers/job_controller.dart';
import '../controllers/template_controller.dart';
import '../controllers/session_controller.dart';
import '../models/job.dart';
import '../models/work_session.dart';
import '../services/hive_service.dart';
import 'add_session_screen.dart';

/// Class holds the session screen
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

/// Class holds the state of the session screen
class _SessionScreenState extends State<SessionScreen> {
  late SessionController sessionController;
  late final JobController _jobController;
  late final TemplateController _templateController;
  List<WorkSession> sessions = [];
  List<WorkSession> _templates = [];
  final List<Tuple2<int, WorkSession>> _recentlyDeletedTemplates = [];

  @override
  void initState() {
    super.initState();
    sessionController = SessionController(HiveService());
    _jobController = JobController(HiveService());
    _templateController = TemplateController(HiveService());
    _loadassetes();
  }

  /// Private method for loading all the assetes from the backend
  void _loadassetes() {
    setState(() {
      sessions = sessionController.getSessionsForJob(widget.jobId);
      _templates = _templateController.getTemplatesForJob(widget.jobId);
    });
  }

  /// Private method for showing the confirmation dialog for deleting a job
  /// Note: Author is Tomáš Zgút
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
                // Note: author is Tomáš Zgút
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
            child: sessions.isNotEmpty
                ? ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      WorkSession session = sessions[index];
                      return Dismissible(
                        key: Key(
                            '${session.jobId}-${session.sessionId}'), // Unique key combining jobId and sessionId
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          // Store session temporarily
                          WorkSession deletedSession = session;
                          int deletedIndex = index;

                          await sessionController.deleteSession(session);
                          setState(() {
                            sessions.removeAt(
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
                                      sessions.insert(
                                          deletedIndex, deletedSession);
                                    });
                                    sessionController.addWorkSessionFromSession(
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
          // Template part of the session screen
          //Note: author is Tomáš Zgút
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
                    : Dismissible(
                        key: Key(
                            '${widget.jobId}-${_templates[index].templateId}'),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          _recentlyDeletedTemplates
                              .add(Tuple2(index, _templates[index]));
                          setState(() {
                            _templates.removeAt(index);
                          });
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                                SnackBar(
                                  content: const Text("Template deleted"),
                                  // undo the template deletion
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      var itemIdx =
                                          _recentlyDeletedTemplates.last.item1;
                                      var item =
                                          _recentlyDeletedTemplates.last.item2;
                                      setState(() {
                                        _templates.insert(itemIdx, item);
                                      });
                                      _recentlyDeletedTemplates.removeLast();
                                    },
                                  ),
                                ),
                              )
                              .closed
                              .then((reason) {
                            // after if the deletion was not undone, delete the template
                            if (reason != SnackBarClosedReason.action) {
                              _templateController
                                  .deleteTemplate(_templates[index]);
                              _loadassetes();
                            }
                          });
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child:
                            // Template button
                            _buildTemplateButton(index),
                      );
              },
            ),
          ),
          const SizedBox(height: 30.0), // Additional spacing below the button
        ],
      ),
    );
  }

  /// Private method for building a template button for a template a given [index]
  /// Note: Author is Tomáš Zgút
  Padding _buildTemplateButton(int index) {
    var template = _templates[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 410, maxHeight: 72),
        child: ElevatedButton(
          onPressed: () {
            sessionController.addWorkSession(widget.jobId,
                templateId: template.templateId);
            _loadassetes();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
            shadowColor: Colors.black.withOpacity(0.1),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Text(
                  '${template.name}',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _pickDate(context, template.templateId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                ),
                child: Row(
                  children: [
                    Text(
                      DateFormat("EEE, d.m.").format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Privte method for building a button that adds a new template
  /// Note: Author is Tomáš Zgút
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
            ).then((_) => _loadassetes());
          },
          label: const Text('Add template',
              style: TextStyle(color: Colors.black), maxLines: 1),
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

  /// Private method for picking a date for a new session
  /// Note: this also creates the session from a template with [templateId]
  /// Note: Author is Tomáš Zgút
  Future<void> _pickDate(BuildContext context, int templateId) async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      sessionController.addWorkSession(widget.jobId,
          templateId: templateId, date: newDate);
      _loadassetes();
    }
  }
}
