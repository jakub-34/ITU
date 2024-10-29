import 'package:hive/hive.dart';
import 'package:itu_app/models/work_session.dart';

part 'job.g.dart'; // Code generation for Hive

@HiveType(typeId: 1)
class Job {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double weekDayRate;

  @HiveField(3)
  double sundayRate;

  @HiveField(4)
  double saturdayRate;

  @HiveField(5)
  double breakHours;

  @HiveField(6)
  double hoursTillBreak;

  Job(
      {required this.id,
      required this.title,
      required this.weekDayRate,
      this.saturdayRate = 0.0,
      this.sundayRate = 0.0,
      this.breakHours = 0.0,
      this.hoursTillBreak = 0.0});

  double getRateForSession(WorkSession session) {
    var sessionDate = session.date;
    var rate = weekDayRate;
    if (sessionDate.day == DateTime.saturday && saturdayRate != 0.0) {
      rate = saturdayRate;
    } else if (sessionDate.day == DateTime.sunday && sundayRate != 0.0) {
      rate = sundayRate;
    }
    return rate;
  }

  double getWorkHoursForSession(WorkSession session) {
    var basicHoursWorked = session.getHoursWorked();
    if (hoursTillBreak == 0.0) {
      return basicHoursWorked;
    }

    var totalHoursWorked = basicHoursWorked -
        (basicHoursWorked / hoursTillBreak).floor() * breakHours;
    print(totalHoursWorked);
    return totalHoursWorked;
  }
}
