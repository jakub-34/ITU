import 'package:hive_flutter/hive_flutter.dart';
import '../models/job.dart';
import '../models/work_session.dart';

class HiveService {
  static const String jobsBox = 'jobsBox';
  static const String sessionsBox = 'sessionsBox';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(JobAdapter());
    Hive.registerAdapter(WorkSessionAdapter());
    await Hive.openBox<Job>(jobsBox);
    await Hive.openBox<WorkSession>(sessionsBox);
  }

  Future<void> addJob(Job job) async {
    var box = Hive.box<Job>(jobsBox);
    await box.add(job);
  }

  Future<void> addWorkSession(WorkSession session) async {
    var box = Hive.box<WorkSession>(sessionsBox);
    await box.add(session);
  }

  List<Job> getAllJobs() {
    print("getting all jobs mf");
    var box = Hive.box<Job>(jobsBox);
    return box.values.toList();
  }

  List<WorkSession> getSessionsForJob(int jobId) {
    var box = Hive.box<WorkSession>(sessionsBox);
    return box.values.where((session) => session.jobId == jobId).toList();
  }

  double calculateMonthlyEarnings() {
    var now = DateTime.now();
    double totalEarnings = 0;
    for (var job in getAllJobs()) {
      totalEarnings += getSessionsForJob(job.id!).fold(0.0, (sum, session) {
        if (session.date.month == now.month && session.date.year == now.year) {
          return sum + (session.hoursWorked * job.hourlyRate + session.extraPay);
        }
        return sum;
      });
    }

    return totalEarnings;
  }
}
