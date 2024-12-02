// author. Tomáš Zgút
import 'package:flutter/material.dart';
import '../services/hive_service.dart';
import '../models/work_session.dart';

/// Class used as an API layer for session templates in the backend
class TemplateController {
  final HiveService hiveService;

  /// class constructor
  TemplateController(this.hiveService);

  ///Method adds a new template to the backend
  Future<void> addTemplate(
      int jobId, TimeOfDay startTime, TimeOfDay endTime, String name) async {
    var template = _createNewTemplate(jobId, startTime, endTime, name);
    await hiveService.addTemplate(template);
  }

  /// Private method for comparing two `TimeOfDay` objects
  bool _cmpTimeOfDay(TimeOfDay fisrt, TimeOfDay second) {
    if (fisrt.hour < second.hour) {
      return true;
    }
    if (fisrt.minute < second.minute) {
      return true;
    }
    return false;
  }

  /// Private method for creating a new session template
  WorkSession _createNewTemplate(
      int jobId, TimeOfDay startTime, TimeOfDay endTime, String name) {
    var id = hiveService.getNewTemplateId();
    var now = DateTime.now();
    var addDay = _cmpTimeOfDay(startTime, endTime) ? 0 : 1;
    return WorkSession(
      sessionId: 0,
      templateId: id,
      jobId: jobId,
      date: now,
      startTime: DateTime(
        now.year,
        now.month,
        now.day,
        startTime.hour,
        startTime.minute,
      ),
      endTime: DateTime(
        now.year,
        now.month,
        now.day + addDay,
        endTime.hour,
        endTime.minute,
      ),
      name: name,
    );
  }

  /// Method returns a list of all templates for a job with [jobId]
  List<WorkSession> getTemplatesForJob(int jobId) {
    return hiveService.getSessionTemplatesForJob(jobId);
  }

  /// Method deletes a [template] from the backend
  Future<void> deleteTemplate(WorkSession template) {
    return hiveService.deleteTemplate(template.jobId, template.templateId);
  }
}
