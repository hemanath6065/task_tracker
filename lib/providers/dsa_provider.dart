import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/models/dsa_problem_model.dart';
import '../data/repositories/dsa_repository.dart';
import '../core/constants/roadmap_data.dart';

final dsaProvider = ChangeNotifierProvider<DsaNotifier>((ref) {
  return DsaNotifier();
});

class DsaNotifier extends ChangeNotifier {
  final DsaRepository _repo = DsaRepository();
  List<DsaProblemModel> _problems = [];
  Map<String, double> _topicProgress = {};
  int _totalSolved = 0;
  bool _isLoading = false;

  List<DsaProblemModel> get problems => _problems;
  Map<String, double> get topicProgress => _topicProgress;
  int get totalSolved => _totalSolved;
  bool get isLoading => _isLoading;

  Future<void> loadProblems() async {
    _isLoading = true;
    notifyListeners();

    _problems = await _repo.getAllProblems();

    if (_problems.isEmpty) {
      await _initializeFromRoadmap();
      _problems = await _repo.getAllProblems();
    }

    _topicProgress = await _repo.getTopicProgress();
    _totalSolved = await _repo.getTotalSolvedCount();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _initializeFromRoadmap() async {
    for (final topic in RoadmapData.dsaTopics) {
      for (final problem in topic['problems'] as List) {
        final model = DsaProblemModel(
          id: const Uuid().v4(),
          name: problem as String,
          topic: topic['name'] as String,
        );
        await _repo.addProblem(model);
      }
    }
  }

  Future<void> toggleSolved(DsaProblemModel problem) async {
    await _repo.toggleSolved(problem);
    await loadProblems();
  }

  Future<void> updateNotes(DsaProblemModel problem, String notes) async {
    problem.notes = notes;
    await _repo.updateProblem(problem);
    notifyListeners();
  }

  Future<void> updateDifficulty(DsaProblemModel problem, String difficulty) async {
    problem.difficulty = difficulty;
    await _repo.updateProblem(problem);
    notifyListeners();
  }

  Future<void> markRevised(DsaProblemModel problem) async {
    problem.revisionCount++;
    problem.lastRevisionDate = DateTime.now();
    await _repo.updateProblem(problem);
    notifyListeners();
  }

  List<DsaProblemModel> getProblemsByTopic(String topic) {
    return _problems.where((p) => p.topic == topic).toList();
  }

  int getSolvedCountForTopic(String topic) {
    return _problems.where((p) => p.topic == topic && p.isSolved).length;
  }

  int getTotalCountForTopic(String topic) {
    return _problems.where((p) => p.topic == topic).length;
  }

  /// Identify strongest topic (highest completion %)
  String? get strongestTopic {
    if (_topicProgress.isEmpty) return null;
    final sorted = _topicProgress.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  /// Identify weakest topic (lowest completion %)
  String? get weakestTopic {
    if (_topicProgress.isEmpty) return null;
    final sorted = _topicProgress.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return sorted.first.key;
  }

  Future<void> clearAll() async {
    await _repo.clearAll();
    await loadProblems();
  }
}
