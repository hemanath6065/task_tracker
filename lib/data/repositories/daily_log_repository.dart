import 'package:hive/hive.dart';
import '../models/daily_log_model.dart';

class DailyLogRepository {
  static const String _boxName = 'daily_logs';

  Future<Box<DailyLogModel>> get _box async =>
      Hive.openBox<DailyLogModel>(_boxName);

  Future<DailyLogModel?> getLogForDate(DateTime date) async {
    final box = await _box;
    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return box.get(key);
  }

  Future<void> saveLog(DailyLogModel log) async {
    final box = await _box;
    final key =
        '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
    await box.put(key, log);
  }

  Future<List<DailyLogModel>> getLogsForWeek() async {
    final box = await _box;
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return box.values.where((log) => log.date.isAfter(weekAgo)).toList();
  }

  Future<int> getTotalStudyMinutes() async {
    final box = await _box;
    int total = 0;
    for (final log in box.values) {
      total += log.studyMinutes;
    }
    return total;
  }

  Future<List<DailyLogModel>> getAllLogs() async {
    final box = await _box;
    return box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> clearAll() async {
    final box = await _box;
    await box.clear();
  }
}
