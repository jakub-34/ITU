import '../models/work_session.dart';
import '../services/hive_service.dart';

class SessionController {
  final HiveService hiveService;

  SessionController(this.hiveService);

  Future<void> addWorkSession(WorkSession session) async {
    await hiveService.addWorkSession(session);
  }

  List<WorkSession> getSessionsForJob(int jobId) {
    return hiveService.getSessionsForJob(jobId);
  }
}
