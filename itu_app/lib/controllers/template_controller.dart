import 'package:flutter/material.dart';

import '../services/hive_service.dart';
import '../models/work_session.dart';

class TemplateController {
  final HiveService hiveService;

  TemplateController(this.hiveService);

  Future<void> addTemplate(
      int jobId, TimeOfDay startTime, TimeOfDay endTime, String name) async {
    var template = _createNewTemplate(jobId, startTime, endTime, name);
    await hiveService.addTemplate(template);
  }

  bool _cmpTimeOfDay(TimeOfDay fisrt, TimeOfDay second) {
    if (fisrt.hour < second.hour) {
      return true;
    }
    if (fisrt.minute < second.minute) {
      return true;
    }
    return false;
  }

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

  List<WorkSession> getTemplatesForJob(int jobId) {
    return hiveService.getSessionTemplatesForJob(jobId);
  }

  Future<void> deleteTemplate(WorkSession template) {
    return hiveService.deleteTemplate(template.jobId, template.templateId);
  }
}
