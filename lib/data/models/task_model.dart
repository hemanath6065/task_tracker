import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? completedAt;

  @HiveField(6)
  int estimatedMinutes;

  @HiveField(7)
  String? notes;

  @HiveField(8)
  String? mood;

  @HiveField(9)
  String category; // 'java', 'spring', 'dsa', 'microservices', etc.

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
    this.estimatedMinutes = 30,
    this.notes,
    this.mood,
    this.category = 'general',
  });
}
