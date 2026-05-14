import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';
import '../core/constants/app_constants.dart';

final taskProvider = ChangeNotifierProvider<TaskNotifier>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends ChangeNotifier {
  final TaskRepository _repo = TaskRepository();
  List<TaskModel> _tasks = [];
  List<TaskModel> _todayTasks = [];
  int _streak = 0;
  int _completedCount = 0;
  Map<DateTime, int> _activityMap = {};
  bool _isLoading = false;

  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get todayTasks => _todayTasks;
  int get streak => _streak;
  int get completedCount => _completedCount;
  Map<DateTime, int> get activityMap => _activityMap;
  bool get isLoading => _isLoading;
  bool get canAddMoreTasks => _todayTasks.length < AppConstants.maxDailyTasks;
  String? get overwhelmMessage =>
      _todayTasks.length >= AppConstants.maxDailyTasks
          ? (AppConstants.antiOverwhelmMessages..shuffle()).first
          : null;

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _repo.getAllTasks();
    _todayTasks = await _repo.getTasksByDate(DateTime.now());
    _streak = await _repo.getCurrentStreak();
    _completedCount = await _repo.getCompletedCount();
    _activityMap = await _repo.getActivityMap();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask({
    required String title,
    String? description,
    int estimatedMinutes = 30,
    String category = 'general',
  }) async {
    final task = TaskModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      estimatedMinutes: estimatedMinutes,
      category: category,
    );
    await _repo.addTask(task);
    await loadTasks();
  }

  Future<void> toggleTask(TaskModel task) async {
    task.isCompleted = !task.isCompleted;
    task.completedAt = task.isCompleted ? DateTime.now() : null;
    await _repo.updateTask(task);
    await loadTasks();
  }

  Future<void> updateTaskNotes(TaskModel task, String notes) async {
    task.notes = notes;
    await _repo.updateTask(task);
    notifyListeners();
  }

  Future<void> updateTaskMood(TaskModel task, String mood) async {
    task.mood = mood;
    await _repo.updateTask(task);
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await _repo.deleteTask(id);
    await loadTasks();
  }

  Future<void> clearAll() async {
    await _repo.clearAll();
    await loadTasks();
  }
}
