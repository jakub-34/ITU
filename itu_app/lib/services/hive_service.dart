// author: Tomáš Zgút
// author Jakub Hrdlička
import 'package:hive_flutter/hive_flutter.dart';
import '../models/job.dart';
import '../models/work_session.dart';

/// Class holds the entire backend for the app
class HiveService {
  static const String jobsBox = 'jobsBox';
  static const String sessionsBox = 'sessionsBox';
  static const String templatesBox = 'templatesBox';

  /// Method for backend initialization
  Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(JobAdapter());
    }

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(WorkSessionAdapter());
    }

    await Hive.openBox<Job>(jobsBox);
    await Hive.openBox<WorkSession>(sessionsBox);
    await Hive.openBox<WorkSession>(templatesBox);
  }

  /// Method adds a [job] into the backend
  Future<void> addJob(Job job) async {
    var box = Hive.box<Job>(jobsBox);
    await box.add(job);
  }

  /// Method adds a [session] into the backend
  Future<void> addWorkSession(WorkSession session) async {
    var box = Hive.box<WorkSession>(sessionsBox);
    await box.add(session);
  }

  /// Method adds a [template] into the backend
  Future<void> addTemplate(WorkSession template) async {
    var box = Hive.box<WorkSession>(templatesBox);
    await box.add(template);
  }

  /// Method deletes a job with a [jobId] and all
  /// its templates and worksessions
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
    await sesionBox.deleteAll(__getSessionKeys(jobId));
    await templateBox.deleteAll(__getTemplateKeys(jobId));
  }

  /// Private method finds all the session keys corresponding
  /// to a [jobId]
  List<dynamic> __getSessionKeys(int jobId) {
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

  /// Private method finds all template keys corresponding
  /// to a [jobId]
  List<dynamic> __getTemplateKeys(int jobId) {
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

  /// Method deletes a [session]
  /// Note: author is Jakub Hrdlička
  Future<void> deleteSession(WorkSession session) async {
    var box = Hive.box<WorkSession>(sessionsBox);

    for (var key in box.keys) {
      WorkSession? boxSession = box.get(key);
      if (boxSession!.jobId == session.jobId &&
          boxSession.sessionId == session.sessionId) {
        await box.delete(key);
      }
    }
  }

  /// Method deletes a tempplate that corresponds with [jobId] and a [templateId]
  Future<void> deleteTemplate(int jobId, int templateId) async {
    var box = Hive.box<WorkSession>(templatesBox);

    for (var key in box.keys) {
      WorkSession? boxTemplate = box.get(key);
      if (boxTemplate!.templateId == templateId && boxTemplate.jobId == jobId) {
        await box.delete(key);
      }
    }
  }

  /// Method returns a list of all jobs sotred in the backend
  List<Job> getAllJobs() {
    var box = Hive.box<Job>(jobsBox);
    return box.values.toList();
  }

  /// Method returns all worksession that correspond with a [jobId]
  List<WorkSession> getSessionsForJob(int jobId) {
    var box = Hive.box<WorkSession>(sessionsBox);
    return box.values.where((session) => session.jobId == jobId).toList();
  }

  /// Method calculates earnings from all jobs in the past month
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

  /// Method celculates hours worked for all jobs in the past month
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

  /// Method calculates earnings from a [job] in the pass month
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

  /// Method calculates hours worked for a  [job] in the pass month
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

  /// Method for creating a unique new id for a job
  int getNewJobId() {
    var jobs = Hive.box<Job>(jobsBox).values.toList();
    if (jobs.isEmpty) {
      return 1;
    }
    return jobs.map((job) => job.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  /// Method for creating a unique new id for a session
  /// Note: Author is Jakub Hrdlička
  int getNewSessionId() {
    var sessions = Hive.box<WorkSession>('sessionsBox').values.toList();
    if (sessions.isEmpty) {
      return 1;
    }
    return sessions
            .map((session) => session.sessionId)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  /// Method for creating a new uinque id for a session template
  int getNewTemplateId(int jobId) {
    var templates = Hive.box<WorkSession>(templatesBox)
        .values
        .where((template) => template.jobId == jobId)
        .toList();
    if (templates.isEmpty) {
      return 0;
    }
    return templates
            .map((template) => template.templateId)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  /// Method returns a list of all session templates for a job with [jobId]
  List<WorkSession> getSessionTemplatesForJob(int jobId) {
    var box = Hive.box<WorkSession>(templatesBox);
    return box.values.where((template) => template.jobId == jobId).toList();
  }
}
