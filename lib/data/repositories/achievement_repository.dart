import 'package:hive/hive.dart';
import '../models/achievement_model.dart';

class AchievementRepository {
  static const String _boxName = 'achievements';

  Future<Box<AchievementModel>> get _box async =>
      Hive.openBox<AchievementModel>(_boxName);

  static final List<AchievementModel> defaultAchievements = [
    AchievementModel(
      id: 'streak_7',
      title: '7 Day Streak',
      description: 'Completed tasks for 7 consecutive days',
      icon: '🔥',
      color: 0xFFFF6B9D,
    ),
    AchievementModel(
      id: 'streak_30',
      title: '30 Day Streak',
      description: 'A full month of consistency!',
      icon: '⚡',
      color: 0xFFFFB340,
    ),
    AchievementModel(
      id: 'oops_complete',
      title: 'OOP Master',
      description: 'Completed all OOPS topics',
      icon: '🏆',
      color: 0xFF00FF88,
    ),
    AchievementModel(
      id: 'first_crud',
      title: 'First CRUD API',
      description: 'Built your first CRUD API',
      icon: '🚀',
      color: 0xFF4D9EFF,
    ),
    AchievementModel(
      id: 'jwt_master',
      title: 'JWT Master',
      description: 'Completed JWT & Spring Security',
      icon: '🔐',
      color: 0xFF8B5CF6,
    ),
    AchievementModel(
      id: 'consistency_champion',
      title: 'Consistency Champion',
      description: 'Completed 100 tasks total',
      icon: '👑',
      color: 0xFFFFB340,
    ),
    AchievementModel(
      id: 'java_basics',
      title: 'Java Foundation',
      description: 'Completed all Java basics',
      icon: '☕',
      color: 0xFF00FF88,
    ),
    AchievementModel(
      id: 'spring_boot',
      title: 'Spring Boot Pro',
      description: 'Completed Spring Boot core topics',
      icon: '🌱',
      color: 0xFF4D9EFF,
    ),
    AchievementModel(
      id: 'dsa_starter',
      title: 'DSA Starter',
      description: 'Solved first 10 DSA problems',
      icon: '🧮',
      color: 0xFF22D3EE,
    ),
    AchievementModel(
      id: 'dsa_warrior',
      title: 'DSA Warrior',
      description: 'Solved 50 DSA problems',
      icon: '⚔️',
      color: 0xFFFF6B9D,
    ),
    AchievementModel(
      id: 'microservices',
      title: 'Microservices Architect',
      description: 'Completed Microservices module',
      icon: '🔗',
      color: 0xFF8B5CF6,
    ),
    AchievementModel(
      id: 'first_task',
      title: 'First Step',
      description: 'Completed your first task',
      icon: '🎯',
      color: 0xFF00FF88,
    ),
  ];

  Future<void> initializeAchievements() async {
    final box = await _box;
    if (box.isEmpty) {
      for (final achievement in defaultAchievements) {
        await box.put(achievement.id, achievement);
      }
    }
  }

  Future<List<AchievementModel>> getAllAchievements() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<void> unlockAchievement(String id) async {
    final box = await _box;
    final achievement = box.get(id);
    if (achievement != null && !achievement.isUnlocked) {
      achievement.isUnlocked = true;
      achievement.unlockedAt = DateTime.now();
      await achievement.save();
    }
  }

  Future<int> getUnlockedCount() async {
    final box = await _box;
    return box.values.where((a) => a.isUnlocked).length;
  }

  Future<void> clearAll() async {
    final box = await _box;
    await box.clear();
  }
}
