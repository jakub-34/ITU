import 'package:hive/hive.dart';

part 'job.g.dart'; // Code generation for Hive

@HiveType(typeId: 0)
class Job {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double hourlyRate;

  Job({this.id, required this.title, required this.hourlyRate});
}
