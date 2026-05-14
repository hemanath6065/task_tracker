import 'package:hive/hive.dart';

part 'achievement_model.g.dart';

@HiveType(typeId: 3)
class AchievementModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String icon;

  @HiveField(4)
  bool isUnlocked;

  @HiveField(5)
  DateTime? unlockedAt;

  @HiveField(6)
  int color;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
    this.color = 0xFF00FF88,
  });
}
