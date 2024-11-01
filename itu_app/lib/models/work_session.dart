import 'package:hive/hive.dart';

part 'work_session.g.dart'; // Code generation for Hive

@HiveType(typeId: 2)
class WorkSession {
  @HiveField(6)
  int sessionId;

  @HiveField(0)
  int templateId;

  @HiveField(1)
  int jobId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  DateTime startTime;

  @HiveField(4)
  DateTime endTime;

  @HiveField(5)
  String? name;

  WorkSession({
    required this.sessionId,
    this.templateId = 0,
    required this.jobId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.name,
  });

  double getHoursWorked() {
    return endTime.difference(startTime).inMinutes / 60.0;
  }
}
