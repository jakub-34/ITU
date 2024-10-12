import 'package:hive/hive.dart';

part 'work_session.g.dart'; // Code generation for Hive

@HiveType(typeId: 1)
class WorkSession {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int jobId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  double hoursWorked;

  @HiveField(4)
  double extraPay;

  WorkSession({
    this.id,
    required this.jobId,
    required this.date,
    required this.hoursWorked,
    this.extraPay = 0.0,
  });
}
