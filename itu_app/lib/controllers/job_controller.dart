import '../models/job.dart';
import '../models/work_session.dart';
import '../services/hive_service.dart';

class JobController {
  final HiveService hiveService;

  JobController(this.hiveService);

  Future<void> addJob(Job job) async {
    await hiveService.addJob(job);
  }

  List<Job> getAllJobs() {
    return hiveService.getAllJobs();
  }
  List<WorkSession> getSessionsForJob(int jobId) {
    return hiveService.getSessionsForJob(jobId);
  }

  double getMonthlyEarnings() {
    return hiveService.calculateMonthlyEarnings();
  }
}
