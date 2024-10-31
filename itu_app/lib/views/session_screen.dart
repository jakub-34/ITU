// session_screen.dart
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
  late SessionController sessionController;
  late JobController jobController;
  late TemplateController templateController;
  List<WorkSession> sessions = [];
  List<WorkSession> templates = [];

  @override
  void initState() {
    super.initState();
    sessionController = SessionController(HiveService());
    jobController = JobController(HiveService());
    templateController = TemplateController(HiveService());
    loadSessions();
  }

  void loadSessions() {
    setState(() {
      sessions = sessionController.getSessionsForJob(widget.jobId);
      templates = templateController.getTemplatesForJob(widget.jobId);
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
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () => {
                        jobController.deleteJob(widget.jobId),
                        Navigator.pop(context),
                        Navigator.pop(context)
                      },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('delete'))
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
            child: sessions.isNotEmpty
                ? ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      WorkSession session = sessions[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              maxWidth: 375, maxHeight: 72),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white, // White background
                              borderRadius:
                                  BorderRadius.circular(60), // Rounded corners
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
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
            child: templates.isNotEmpty
                ? ListView.builder(
                    itemCount: templates.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxWidth: 500, maxHeight: 150),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            sessionController.addWorkSession(
                                widget.jobId, index);
                            loadSessions();
                          },
                          label: Text('${templates[index].name}',
                              style: const TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 138, vertical: 25),
                            backgroundColor:
                                Colors.white, // White button background
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No shfit types added yet!',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 150),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddSessionScreen(job: widget.job),
                  ),
                ).then((_) => loadSessions());
              },
              label: const Text('Add workday',
                  style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 138, vertical: 25),
                backgroundColor: Colors.white, // White button background
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Add New Job button
          const SizedBox(height: 30.0), // Additional spacing below the button
        ],
      ),
    );
  }
}
