import 'package:flutter/material.dart';

import '../models/work_session.dart';
import '../services/hive_service.dart';

class SessionController {
  final HiveService hiveService;

  SessionController(this.hiveService);

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

  List<WorkSession> getSessionsForJob(int jobId) {
    var sessionList = hiveService.getSessionsForJob(jobId);
    sessionList.sort((a, b) => a.date.compareTo(b.date));
    return sessionList.reversed.toList();
  }

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

  DateTime _cnvrtToDatetime(TimeOfDay time, DateTime date) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

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

  Future<void> deleteSession(WorkSession session) {
    return hiveService.deleteSession(session);
  }

  void addWorkSessionFromSession(WorkSession session) {
    hiveService.addWorkSession(session);
  }
}
