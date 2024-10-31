import 'package:hive_flutter/hive_flutter.dart';
import '../models/job.dart';
import '../models/work_session.dart';

class HiveService {
  static const String jobsBox = 'jobsBox';
  static const String sessionsBox = 'sessionsBox';
  static const String templatesBox = 'templatesBox';

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
    // await Hive.deleteBoxFromDisk(sessionsBox);
    // await Hive.deleteBoxFromDisk(templatesBox);
    // await Hive.deleteBoxFromDisk(jobsBox);

    await Hive.openBox<Job>(jobsBox);
    await Hive.openBox<WorkSession>(sessionsBox);
    await Hive.openBox<WorkSession>(templatesBox);
  }

  Future<void> addJob(Job job) async {
    var box = Hive.box<Job>(jobsBox);
    await box.add(job);
  }

  Future<void> addWorkSession(WorkSession session) async {
    var box = Hive.box<WorkSession>(sessionsBox);
    await box.add(session);
  }

  Future<void> addTemplate(WorkSession template) async {
    var box = Hive.box<WorkSession>(templatesBox);
    await box.add(template);
  }

  Future<void> deleteJob(int jobId) async {
    var jobBox = Hive.box<Job>(jobsBox);
    var sesionBox = Hive.box<WorkSession>(sessionsBox);
    var templateBox = Hive.box<WorkSession>(templatesBox);
    for (var key in jobBox.keys) {
      Job? job = jobBox.get(key);
      if (job!.id == jobId) {
        await jobBox.delete(key);
      }
    }
    await sesionBox.deleteAll(getSessionKeys(jobId));
    await templateBox.deleteAll(getTemplateKeys(jobId));
  }

  List<dynamic> getSessionKeys(int jobId) {
    var box = Hive.box<WorkSession>(sessionsBox);
    var sessionKeys = [];

    for (var key in box.keys) {
      WorkSession? session = box.get(key);
      if (session!.jobId == jobId) {
        sessionKeys.add(key);
      }
    }
    return sessionKeys;
  }

  List<dynamic> getTemplateKeys(int jobId) {
    var box = Hive.box<WorkSession>(templatesBox);
    var sessionKeys = [];

    for (var key in box.keys) {
      WorkSession? session = box.get(key);
      if (session!.jobId == jobId) {
        sessionKeys.add(key);
      }
    }
    return sessionKeys;
  }

  Future<void> deleteSession(WorkSession session) async {
    var box = Hive.box<WorkSession>(sessionsBox);

    for (var key in box.keys) {
      WorkSession? boxSession = box.get(key);
      if (boxSession!.date == session.date &&
          boxSession.jobId == session.jobId) {
        await box.delete(key);
      }
    }
  }

  Future<void> deleteTemplate(int jobId, int templateId) async {
    var box = Hive.box<WorkSession>(templatesBox);

    for (var key in box.keys) {
      WorkSession? boxTemplate = box.get(key);
      if (boxTemplate!.templateId == templateId && boxTemplate.jobId == jobId) {
        await box.delete(key);
      }
    }
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
              job.getWorkHoursForSession(session) *
                  job.getRateForSession(session);
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
          return sum + job.getWorkHoursForSession(session);
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
        return sum +
            job.getWorkHoursForSession(session) *
                job.getRateForSession(session);
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
        return sum + job.getWorkHoursForSession(session);
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

  int getNewTemplateId() {
    var templates = Hive.box<WorkSession>(templatesBox).values.toList();
    if (templates.isEmpty) {
      return 0;
    }
    return templates
            .map((template) => template.templateId)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  List<WorkSession> getSessionTemplatesForJob(int jobId) {
    var box = Hive.box<WorkSession>(templatesBox);
    return box.values.where((template) => template.jobId == jobId).toList();
  }
}
