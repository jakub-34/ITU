import 'package:hive_flutter/hive_flutter.dart';
import '../models/job.dart';
import '../models/work_session.dart';

class HiveService {
  static const String jobsBox = 'jobsBox';
  static const String sessionsBox = 'sessionsBox';

  Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(JobAdapter());
    }

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(WorkSessionAdapter());
    }

    /* the following 2 lines delete the saved data from the app
        they are only needed once after the fix remove them later 
        (or comment them out in case of a fuck up XD)
     */
    // await Hive.deleteBoxFromDisk(jobsBox);
    // await Hive.deleteBoxFromDisk(sessionsBox);

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
      totalEarnings += getSessionsForJob(job.id).fold(0.0, (sum, session) {
        if (session.date.month == now.month && session.date.year == now.year) {
          return sum +
              (session.hoursWorked * job.hourlyRate + session.extraPay);
        }
        return sum;
      });
    }

    return totalEarnings;
  }

  double calculateMonthlyHours() {
    var now = DateTime.now();
    double totalHoursWorked = 0;
    for (var job in getAllJobs()) {
      totalHoursWorked += getSessionsForJob(job.id).fold(0.0, (sum, session) {
        if (session.date.month == now.month && session.date.year == now.year) {
          return sum + session.hoursWorked;
        }
        return sum;
      });
    }
    return totalHoursWorked;
  }

  double calculateMonthlyEarningsForJob(Job job) {
    var sessions = getSessionsForJob(job.id);
    double totalEarnings = sessions.fold(0.0, (sum, session) {
      if (session.date.month == DateTime.now().month &&
          session.date.year == DateTime.now().year) {
        return sum + session.hoursWorked * job.hourlyRate + session.extraPay;
      }
      return sum;
    });
    return totalEarnings;
  }

  double calculateMonthlyHoursForJob(Job job) {
    var sessions = getSessionsForJob(job.id);
    double totalHoursWorked = sessions.fold(0.0, (sum, session) {
      if (session.date.month == DateTime.now().month &&
          session.date.year == DateTime.now().year) {
        return sum + session.hoursWorked;
      }
      return sum;
    });
    return totalHoursWorked;
  }

  int getNewJobId() {
    var jobs = Hive.box<Job>(jobsBox).values.toList();
    if (jobs.isEmpty) {
      return 1;
    }
    return jobs.map((job) => job.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  int getNewSessionId() {
    var sessions = Hive.box<WorkSession>(sessionsBox).values.toList();
    if (sessions.isEmpty) {
      return 1;
    }
    return sessions
            .map((session) => session.id)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }
}
