import '../models/work_session.dart';
import '../services/hive_service.dart';

class SessionController {
  final HiveService hiveService;

  SessionController(this.hiveService);

  Future<void> addWorkSession(
      int jobId, DateTime date, double hoursWorked, double extraPay) async {
    WorkSession session = _createNewSession(jobId, date, hoursWorked, extraPay);
    await hiveService.addWorkSession(session);
  }

  List<WorkSession> getSessionsForJob(int jobId) {
    return hiveService.getSessionsForJob(jobId);
  }

  WorkSession _createNewSession(
      int jobId, DateTime date, double hoursWorked, double extraPay) {
    var id = hiveService.getNewSessionId();
    return WorkSession(
        id: id,
        jobId: jobId,
        date: date,
        hoursWorked: hoursWorked,
        extraPay: extraPay);
  }
}
