// author: Tomáš Zgút
import '../models/job.dart';
import '../models/work_session.dart';
import '../services/hive_service.dart';

/// Class used as an API layer for jobs in the backend
class JobController {
  final HiveService hiveService;

  /// Class constructor
  JobController(this.hiveService);

  /// Method adds a new job to the backend
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

  /// Method returns a list of all jobs
  List<Job> getAllJobs() {
    return hiveService.getAllJobs();
  }

  /// Method reurns a list of all sessions for a givne job in the past month
  List<WorkSession> getSessionsForJob(int jobId) {
    return hiveService.getSessionsForJob(jobId);
  }

  /// Method calcualtes eraging from all jobs in the past moth
  double getMonthlyEarnings() {
    return hiveService.calculateMonthlyEarnings();
  }

  /// Method calcualtes worked hours for all jobs in the past month
  double getMonthlyHours() {
    return hiveService.calculateMonthlyHours();
  }

  /// Method calculates earnings from a [job] in the past month
  double getMonthlyEarningsForJob(Job job) {
    return hiveService.calculateMonthlyEarningsForJob(job);
  }

  /// Method caltulates hors worked for a [job] in the past month
  double getMonthlyHoursForJob(Job job) {
    return hiveService.calculateMonthlyHoursForJob(job);
  }

  /// Method deletes a job with a given [jobid]
  void deleteJob(int jobId) {
    hiveService.deleteJob(jobId);
  }

  /// Private method for creating a new job
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
