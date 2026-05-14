import 'package:hive/hive.dart';
import '../models/topic_model.dart';

class TopicRepository {
  static const String _boxName = 'topics';

  Future<Box<TopicModel>> get _box async => Hive.openBox<TopicModel>(_boxName);

  Future<List<TopicModel>> getAllTopics() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<List<TopicModel>> getTopicsByPhase(int phase) async {
    final box = await _box;
    return box.values.where((t) => t.phase == phase).toList();
  }

  Future<List<TopicModel>> getTopicsByParent(String parentTopic) async {
    final box = await _box;
    return box.values.where((t) => t.parentTopic == parentTopic).toList();
  }

  Future<void> addTopic(TopicModel topic) async {
    final box = await _box;
    await box.put(topic.id, topic);
  }

  Future<void> updateTopic(TopicModel topic) async {
    await topic.save();
  }

  Future<void> toggleCompletion(TopicModel topic) async {
    topic.isCompleted = !topic.isCompleted;
    topic.completedAt = topic.isCompleted ? DateTime.now() : null;
    if (topic.isCompleted) {
      // Set revision reminders
      topic.revisionCount++;
      topic.lastRevisionDate = DateTime.now();
      topic.nextRevisionDate = DateTime.now().add(const Duration(days: 1));
    }
    await topic.save();
  }

  Future<double> getPhaseProgress(int phase) async {
    final topics = await getTopicsByPhase(phase);
    if (topics.isEmpty) return 0;
    final completed = topics.where((t) => t.isCompleted).length;
    return completed / topics.length;
  }

  Future<double> getOverallProgress() async {
    final box = await _box;
    final all = box.values.toList();
    if (all.isEmpty) return 0;
    final completed = all.where((t) => t.isCompleted).length;
    return completed / all.length;
  }

  Future<List<TopicModel>> getDueRevisions() async {
    final box = await _box;
    final now = DateTime.now();
    return box.values.where((t) {
      return t.isCompleted &&
          t.nextRevisionDate != null &&
          t.nextRevisionDate!.isBefore(now);
    }).toList();
  }

  Future<void> markRevised(TopicModel topic) async {
    topic.revisionCount++;
    topic.lastRevisionDate = DateTime.now();
    // Spaced repetition: 1 day, 7 days, 30 days
    if (topic.revisionCount <= 1) {
      topic.nextRevisionDate = DateTime.now().add(const Duration(days: 1));
    } else if (topic.revisionCount <= 2) {
      topic.nextRevisionDate = DateTime.now().add(const Duration(days: 7));
    } else {
      topic.nextRevisionDate = DateTime.now().add(const Duration(days: 30));
    }
    await topic.save();
  }

  Future<void> clearAll() async {
    final box = await _box;
    await box.clear();
  }
}
