import 'package:hive/hive.dart';
import '../models/dsa_problem_model.dart';

class DsaRepository {
  static const String _boxName = 'dsa_problems';

  Future<Box<DsaProblemModel>> get _box async =>
      Hive.openBox<DsaProblemModel>(_boxName);

  Future<List<DsaProblemModel>> getAllProblems() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<List<DsaProblemModel>> getProblemsByTopic(String topic) async {
    final box = await _box;
    return box.values.where((p) => p.topic == topic).toList();
  }

  Future<void> addProblem(DsaProblemModel problem) async {
    final box = await _box;
    await box.put(problem.id, problem);
  }

  Future<void> updateProblem(DsaProblemModel problem) async {
    await problem.save();
  }

  Future<void> toggleSolved(DsaProblemModel problem) async {
    problem.isSolved = !problem.isSolved;
    problem.solvedAt = problem.isSolved ? DateTime.now() : null;
    await problem.save();
  }

  Future<int> getSolvedCount(String topic) async {
    final problems = await getProblemsByTopic(topic);
    return problems.where((p) => p.isSolved).length;
  }

  Future<int> getTotalSolvedCount() async {
    final box = await _box;
    return box.values.where((p) => p.isSolved).length;
  }

  Future<Map<String, double>> getTopicProgress() async {
    final box = await _box;
    final Map<String, List<DsaProblemModel>> grouped = {};
    
    for (final problem in box.values) {
      grouped.putIfAbsent(problem.topic, () => []).add(problem);
    }

    final Map<String, double> progress = {};
    for (final entry in grouped.entries) {
      final solved = entry.value.where((p) => p.isSolved).length;
      progress[entry.key] = entry.value.isEmpty ? 0 : solved / entry.value.length;
    }

    return progress;
  }

  Future<void> clearAll() async {
    final box = await _box;
    await box.clear();
  }
}
