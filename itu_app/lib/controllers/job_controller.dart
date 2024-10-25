import '../models/job.dart';
import '../models/work_session.dart';
import '../services/hive_service.dart';

class JobController {
  final HiveService hiveService;

  JobController(this.hiveService);

  Future<void> addJob(String title, double hourlyRate) async {
    var newJob = _createNewJob(title, hourlyRate);
    await hiveService.addJob(newJob);
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

  double getMonthlyHours() {
    return hiveService.calculateMonthlyHours();
  }

  double getMonthlyEarningsForJob(Job job) {
    return hiveService.calculateMonthlyEarningsForJob(job);
  }

  double getMonthlyHoursForJob(Job job) {
    return hiveService.calculateMonthlyHoursForJob(job);
  }

  Job _createNewJob(String title, double hourlyRate) {
    var id = hiveService.getNewJobId();
    return Job(id: id, title: title, hourlyRate: hourlyRate);
  }
}
