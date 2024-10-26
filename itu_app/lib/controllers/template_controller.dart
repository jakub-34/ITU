import '../services/hive_service.dart';
import '../models/work_session.dart';

class TemplateController {
  final HiveService hiveService;

  TemplateController(this.hiveService);

  Future<void> addTemplate(
      int jobId, DateTime startTime, DateTime endTime) async {
    var template = _createNewTemplate(jobId, startTime, endTime);
    await hiveService.addTemplate(template);
  }

  WorkSession _createNewTemplate(
      int jobId, DateTime startTime, DateTime endTime) {
    int id = hiveService.getNewTemplateId();
    var startTimeD = startTime.hour + startTime.minute / 60.0;
    var endTimeD = endTime.hour + endTime.minute / 60.0;
    return WorkSession(
        templateId: id,
        jobId: jobId,
        date: DateTime.now(),
        startTime: startTimeD,
        endTime: endTimeD);
  }

  List<WorkSession> getTemplatesForJob(int jobId) {
    return hiveService.getSessionTemplatesForJob(jobId);
  }

  Future<void> deleteTemplate(WorkSession template) {
    return hiveService.deleteTemplate(template.jobId, template.templateId);
  }
}
