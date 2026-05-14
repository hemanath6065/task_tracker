import 'package:hive/hive.dart';
import '../models/task_model.dart';

class TaskRepository {
  static const String _boxName = 'tasks';

  Future<Box<TaskModel>> get _box async => Hive.openBox<TaskModel>(_boxName);

  Future<List<TaskModel>> getAllTasks() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<List<TaskModel>> getTasksByDate(DateTime date) async {
    final box = await _box;
    return box.values.where((task) {
      return task.createdAt.year == date.year &&
          task.createdAt.month == date.month &&
          task.createdAt.day == date.day;
    }).toList();
  }

  Future<void> addTask(TaskModel task) async {
    final box = await _box;
    await box.put(task.id, task);
  }

  Future<void> updateTask(TaskModel task) async {
    await task.save();
  }

  Future<void> deleteTask(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  Future<int> getCompletedCount() async {
    final box = await _box;
    return box.values.where((t) => t.isCompleted).length;
  }

  Future<int> getTodayTaskCount() async {
    final now = DateTime.now();
    final tasks = await getTasksByDate(now);
    return tasks.length;
  }

  Future<int> getCurrentStreak() async {
    final box = await _box;
    final allTasks = box.values.toList();
    
    if (allTasks.isEmpty) return 0;

    // Get unique dates where tasks were completed
    final completedDates = <DateTime>{};
    for (final task in allTasks) {
      if (task.isCompleted && task.completedAt != null) {
        final date = DateTime(
          task.completedAt!.year,
          task.completedAt!.month,
          task.completedAt!.day,
        );
        completedDates.add(date);
      }
    }

    if (completedDates.isEmpty) return 0;

    final sortedDates = completedDates.toList()..sort((a, b) => b.compareTo(a));
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    
    // Check if today or yesterday has activity
    if (sortedDates.first.difference(today).inDays < -1) return 0;

    int streak = 1;
    for (int i = 0; i < sortedDates.length - 1; i++) {
      final diff = sortedDates[i].difference(sortedDates[i + 1]).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  Future<Map<DateTime, int>> getActivityMap() async {
    final box = await _box;
    final Map<DateTime, int> activityMap = {};
    
    for (final task in box.values) {
      if (task.isCompleted && task.completedAt != null) {
        final date = DateTime(
          task.completedAt!.year,
          task.completedAt!.month,
          task.completedAt!.day,
        );
        activityMap[date] = (activityMap[date] ?? 0) + 1;
      }
    }

    return activityMap;
  }

  Future<void> clearAll() async {
    final box = await _box;
    await box.clear();
  }
}
