import 'package:hive/hive.dart';

part 'daily_log_model.g.dart';

@HiveType(typeId: 2)
class DailyLogModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  int studyMinutes;

  @HiveField(3)
  int tasksCompleted;

  @HiveField(4)
  int totalTasks;

  @HiveField(5)
  String? mood;

  @HiveField(6)
  String? reflection;

  DailyLogModel({
    required this.id,
    required this.date,
    this.studyMinutes = 0,
    this.tasksCompleted = 0,
    this.totalTasks = 0,
    this.mood,
    this.reflection,
  });
}
