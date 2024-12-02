// author: Tomáš Zgút
// author: Jakub Hrdlička
import 'package:flutter/material.dart';
import '../models/work_session.dart';
import '../services/hive_service.dart';

/// Class used as an API layer for worksessions in the backend
class SessionController {
  final HiveService hiveService;

  /// class constructor
  SessionController(this.hiveService);

  /// Method adds a new worksession into the backend
  Future<void> addWorkSession(
    int jobId, {
    int? templateId,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) async {
    WorkSession session;
    date ??= DateTime.now();
    if (templateId != null) {
      session = _createTemplatedSession(jobId, templateId, date);
    } else {
      var startDateTime = _cnvrtToDatetime(startTime!, date);
      var endDateTime = _cnvrtToDatetime(endTime!, date);
      if (endDateTime.compareTo(startDateTime) < 0) {
        endDateTime.add(const Duration(days: 1));
      }
      session = _createNewSession(jobId, date, startDateTime, endDateTime);
    }
    await hiveService.addWorkSession(session);
  }

  /// Method retursn a list of all sessions for a job with a [jobId]
  /// List of sessions if sorted by their date in a descending order
  List<WorkSession> getSessionsForJob(int jobId) {
    var sessionList = hiveService.getSessionsForJob(jobId);
    sessionList.sort((a, b) => a.date.compareTo(b.date));
    return sessionList.reversed.toList();
  }

  /// Private method that creates a new worksession from a given templpate
  WorkSession _createTemplatedSession(
      int jobId, int templateId, DateTime date) {
    var sessionId = hiveService.getNewSessionId();
    var template = hiveService.getSessionTemplatesForJob(jobId)[templateId];
    return WorkSession(
        sessionId: sessionId,
        jobId: jobId,
        date: date,
        startTime: template.startTime,
        endTime: template.endTime);
  }

  /// Private method for Combing a [time] with a [date]
  /// Method returns a DateTime object whose date is [date] and time is [time]
  DateTime _cnvrtToDatetime(TimeOfDay time, DateTime date) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  /// Private method that creates a new Worksession
  WorkSession _createNewSession(
      int jobId, DateTime date, DateTime startTime, DateTime endTime) {
    var sessionId = hiveService.getNewSessionId();
    return WorkSession(
      sessionId: sessionId,
      jobId: jobId,
      date: date,
      startTime: startTime,
      endTime: endTime,
    );
  }

  /// Method that deletes a given [session]
  /// Note: author is Jakub Hrdlička
  Future<void> deleteSession(WorkSession session) {
    return hiveService.deleteSession(session);
  }

  /// Method that adds a given [session] into the backend
  /// Note: author is Jakub Hrdlička
  void addWorkSessionFromSession(WorkSession session) {
    hiveService.addWorkSession(session);
  }
}
