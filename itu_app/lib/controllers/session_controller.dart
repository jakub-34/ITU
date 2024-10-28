import '../models/work_session.dart';
import '../services/hive_service.dart';

class SessionController {
  final HiveService hiveService;

  SessionController(this.hiveService);

  Future<void> addWorkSession(int jobId, int templateId) async {
    WorkSession session = _createNewSession(jobId, templateId);
    await hiveService.addWorkSession(session);
  }

  List<WorkSession> getSessionsForJob(int jobId) {
    return hiveService.getSessionsForJob(jobId);
  }

  WorkSession _createNewSession(int jobId, int templateId) {
    var template = hiveService.getSessionTemplatesForJob(jobId)[templateId];
    return WorkSession(
        jobId: jobId,
        date: DateTime.now(),
        startTime: template.startTime,
        endTime: template.endTime);
  }

  Future<void> deleteSession(WorkSession session) {
    return hiveService.deleteSession(session);
  }
}
