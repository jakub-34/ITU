import 'package:hive/hive.dart';

part 'work_session.g.dart'; // Code generation for Hive

@HiveType(typeId: 2)
class WorkSession {
  @HiveField(0)
  int templateId;

  @HiveField(1)
  int jobId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  double startTime;

  @HiveField(4)
  double endTime;

  WorkSession({
    this.templateId = 0,
    required this.jobId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  double getHoursWorked() {
    return endTime - startTime;
  }
}
