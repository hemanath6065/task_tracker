import 'package:hive/hive.dart';

part 'topic_model.g.dart';

@HiveType(typeId: 1)
class TopicModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int phase;

  @HiveField(3)
  String parentTopic; // e.g., 'OOPS'

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  DateTime? completedAt;

  @HiveField(6)
  String difficulty; // Easy, Medium, Hard, Expert

  @HiveField(7)
  int revisionCount;

  @HiveField(8)
  DateTime? lastRevisionDate;

  @HiveField(9)
  DateTime? nextRevisionDate;

  @HiveField(10)
  String? notes;

  TopicModel({
    required this.id,
    required this.name,
    required this.phase,
    required this.parentTopic,
    this.isCompleted = false,
    this.completedAt,
    this.difficulty = 'Medium',
    this.revisionCount = 0,
    this.lastRevisionDate,
    this.nextRevisionDate,
    this.notes,
  });
}
