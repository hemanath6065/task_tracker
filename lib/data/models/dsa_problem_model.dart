import 'package:hive/hive.dart';

part 'dsa_problem_model.g.dart';

@HiveType(typeId: 4)
class DsaProblemModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String topic; // e.g., 'Arrays', 'Trees'

  @HiveField(3)
  bool isSolved;

  @HiveField(4)
  DateTime? solvedAt;

  @HiveField(5)
  String difficulty;

  @HiveField(6)
  int revisionCount;

  @HiveField(7)
  String? notes;

  @HiveField(8)
  DateTime? lastRevisionDate;

  DsaProblemModel({
    required this.id,
    required this.name,
    required this.topic,
    this.isSolved = false,
    this.solvedAt,
    this.difficulty = 'Medium',
    this.revisionCount = 0,
    this.notes,
    this.lastRevisionDate,
  });
}
