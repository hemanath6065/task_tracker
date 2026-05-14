import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data/models/topic_model.dart';
import '../data/repositories/topic_repository.dart';
import '../core/constants/roadmap_data.dart';

final topicProvider = ChangeNotifierProvider<TopicNotifier>((ref) {
  return TopicNotifier();
});

class TopicNotifier extends ChangeNotifier {
  final TopicRepository _repo = TopicRepository();
  List<TopicModel> _topics = [];
  double _overallProgress = 0;
  Map<int, double> _phaseProgress = {};
  List<TopicModel> _dueRevisions = [];
  bool _isLoading = false;

  List<TopicModel> get topics => _topics;
  double get overallProgress => _overallProgress;
  Map<int, double> get phaseProgress => _phaseProgress;
  List<TopicModel> get dueRevisions => _dueRevisions;
  bool get isLoading => _isLoading;

  Future<void> loadTopics() async {
    _isLoading = true;
    notifyListeners();

    _topics = await _repo.getAllTopics();

    // Initialize topics from roadmap data if empty
    if (_topics.isEmpty) {
      await _initializeFromRoadmap();
      _topics = await _repo.getAllTopics();
    }

    _overallProgress = await _repo.getOverallProgress();
    _phaseProgress = {};
    for (int i = 1; i <= 3; i++) {
      _phaseProgress[i] = await _repo.getPhaseProgress(i);
    }
    _dueRevisions = await _repo.getDueRevisions();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _initializeFromRoadmap() async {
    for (final phase in RoadmapData.phases) {
      for (final topic in phase['topics'] as List) {
        for (final subtopic in topic['subtopics'] as List) {
          final topicModel = TopicModel(
            id: const Uuid().v4(),
            name: subtopic as String,
            phase: phase['phase'] as int,
            parentTopic: topic['name'] as String,
          );
          await _repo.addTopic(topicModel);
        }
      }
    }
  }

  Future<void> toggleTopic(TopicModel topic) async {
    await _repo.toggleCompletion(topic);
    await loadTopics();
  }

  Future<void> updateNotes(TopicModel topic, String notes) async {
    topic.notes = notes;
    await _repo.updateTopic(topic);
    notifyListeners();
  }

  Future<void> updateDifficulty(TopicModel topic, String difficulty) async {
    topic.difficulty = difficulty;
    await _repo.updateTopic(topic);
    notifyListeners();
  }

  Future<void> markRevised(TopicModel topic) async {
    await _repo.markRevised(topic);
    await loadTopics();
  }

  List<TopicModel> getSubtopics(String parentTopic, int phase) {
    return _topics
        .where((t) => t.parentTopic == parentTopic && t.phase == phase)
        .toList();
  }

  double getParentProgress(String parentTopic, int phase) {
    final subtopics = getSubtopics(parentTopic, phase);
    if (subtopics.isEmpty) return 0;
    return subtopics.where((t) => t.isCompleted).length / subtopics.length;
  }

  Future<void> clearAll() async {
    await _repo.clearAll();
    await loadTopics();
  }

  /// Get the name of the current learning phase based on progress
  String get currentPhaseName {
    if (_phaseProgress[1] != null && _phaseProgress[1]! < 1.0) {
      return 'Java Basics';
    } else if (_phaseProgress[2] != null && _phaseProgress[2]! < 1.0) {
      return 'Spring Boot';
    } else if (_phaseProgress[3] != null && _phaseProgress[3]! < 1.0) {
      return 'Microservices';
    }
    return 'All Complete!';
  }
}
