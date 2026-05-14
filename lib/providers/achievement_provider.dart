import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/achievement_model.dart';
import '../data/repositories/achievement_repository.dart';

final achievementProvider = ChangeNotifierProvider<AchievementNotifier>((ref) {
  return AchievementNotifier();
});

class AchievementNotifier extends ChangeNotifier {
  final AchievementRepository _repo = AchievementRepository();
  List<AchievementModel> _achievements = [];
  int _unlockedCount = 0;

  List<AchievementModel> get achievements => _achievements;
  int get unlockedCount => _unlockedCount;
  int get totalCount => _achievements.length;

  Future<void> loadAchievements() async {
    await _repo.initializeAchievements();
    _achievements = await _repo.getAllAchievements();
    _unlockedCount = await _repo.getUnlockedCount();
    notifyListeners();
  }

  Future<void> checkAndUnlock({
    required int streak,
    required int completedTasks,
    required int dsaSolved,
    required double oopsProgress,
    required double jwtProgress,
    required double javaProgress,
    required double springProgress,
    required double microservicesProgress,
  }) async {
    if (streak >= 7) await _repo.unlockAchievement('streak_7');
    if (streak >= 30) await _repo.unlockAchievement('streak_30');
    if (completedTasks >= 1) await _repo.unlockAchievement('first_task');
    if (completedTasks >= 100) {
      await _repo.unlockAchievement('consistency_champion');
    }
    if (dsaSolved >= 10) await _repo.unlockAchievement('dsa_starter');
    if (dsaSolved >= 50) await _repo.unlockAchievement('dsa_warrior');
    if (oopsProgress >= 1.0) await _repo.unlockAchievement('oops_complete');
    if (jwtProgress >= 1.0) await _repo.unlockAchievement('jwt_master');
    if (javaProgress >= 1.0) await _repo.unlockAchievement('java_basics');
    if (springProgress >= 1.0) await _repo.unlockAchievement('spring_boot');
    if (microservicesProgress >= 1.0) {
      await _repo.unlockAchievement('microservices');
    }

    _achievements = await _repo.getAllAchievements();
    _unlockedCount = await _repo.getUnlockedCount();
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _repo.clearAll();
    await loadAchievements();
  }
}
