import '../models/job.dart';
import '../models/work_session.dart';
import '../services/hive_service.dart';

class JobController {
  final HiveService hiveService;

  JobController(this.hiveService);

  Future<void> addJob(String title, double weekDayRate,
      [double saturdayRate = 0.0,
      double sundayRate = 0.0,
      double breakHours = 0.0,
      double hoursTillBreak = 0.0,
      bool useTemplates = false]) async {
    var newJob = _createNewJob(title, weekDayRate, saturdayRate, sundayRate,
        breakHours, hoursTillBreak, useTemplates);
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

  void deleteJob(int jobId) {
    hiveService.deleteJob(jobId);
  }

  Job _createNewJob(String title, double weekDayRate,
      [double saturdayRate = 0.0,
      double sundayRate = 0.0,
      double breakHours = 0.0,
      double hoursTillBreak = 0.0,
      bool useTemplates = false]) {
    var id = hiveService.getNewJobId();
    return Job(
        id: id,
        title: title,
        weekDayRate: weekDayRate,
        saturdayRate: saturdayRate,
        sundayRate: sundayRate,
        breakHours: breakHours,
        hoursTillBreak: hoursTillBreak,
        usesTepmates: useTemplates);
  }
}
