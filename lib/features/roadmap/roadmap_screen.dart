import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/roadmap_data.dart';
import '../../core/widgets/glassmorphic_card.dart';
import '../../core/widgets/neon_progress_bar.dart';
import '../../providers/topic_provider.dart';
import '../../data/models/topic_model.dart';

class RoadmapScreen extends ConsumerStatefulWidget {
  const RoadmapScreen({super.key});
  @override
  ConsumerState<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends ConsumerState<RoadmapScreen> {
  int _expandedPhase = -1;
  String? _expandedTopic;

  @override
  Widget build(BuildContext context) {
    final topicState = ref.watch(topicProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Roadmap', style: AppTypography.heading2)
                        .animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 4),
                    Text('Your structured learning path',
                        style: AppTypography.bodyMedium)
                        .animate().fadeIn(duration: 400.ms, delay: 100.ms),
                    const SizedBox(height: 16),
                    _buildOverallProgress(topicState),
                    if (topicState.dueRevisions.isNotEmpty)
                      _buildRevisionReminder(topicState),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final phase = RoadmapData.phases[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: _buildPhaseCard(phase, topicState, index),
                );
              }, childCount: RoadmapData.phases.length),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallProgress(TopicNotifier topicState) {
    return GlassmorphicCard(
      borderColor: AppColors.neonGreen.withValues(alpha: 0.2),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Overall Progress', style: AppTypography.labelLarge),
          Text('${(topicState.overallProgress * 100).toInt()}%',
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 20, fontWeight: FontWeight.w700,
                  color: AppColors.neonGreen)),
        ]),
        const SizedBox(height: 8),
        NeonProgressBar(progress: topicState.overallProgress, height: 8),
      ]),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }

  Widget _buildRevisionReminder(TopicNotifier topicState) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GlassmorphicCard(
        borderColor: AppColors.amber.withValues(alpha: 0.3),
        gradient: LinearGradient(colors: [
          AppColors.amber.withValues(alpha: 0.1),
          AppColors.amber.withValues(alpha: 0.02),
        ]),
        child: Row(children: [
          const Text('🔄', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${topicState.dueRevisions.length} topics due for revision',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.amber)),
              Text('Spaced repetition keeps knowledge fresh',
                  style: AppTypography.bodySmall),
            ],
          )),
        ]),
      ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
    );
  }

  Widget _buildPhaseCard(Map<String, dynamic> phase, TopicNotifier topicState, int index) {
    final phaseNum = phase['phase'] as int;
    final isExpanded = _expandedPhase == phaseNum;
    final progress = topicState.phaseProgress[phaseNum] ?? 0;
    final color = Color(phase['color'] as int);

    return GlassmorphicCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.zero,
      borderColor: isExpanded ? color.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.05),
      child: Column(children: [
        InkWell(
          onTap: () => setState(() {
            _expandedPhase = isExpanded ? -1 : phaseNum;
            _expandedTopic = null;
          }),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text(phase['icon'] as String,
                      style: const TextStyle(fontSize: 22))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PHASE $phaseNum', style: AppTypography.labelSmall
                        .copyWith(color: color, letterSpacing: 1.5)),
                    const SizedBox(height: 2),
                    Text(phase['title'] as String, style: AppTypography.labelLarge),
                  ],
                )),
                Text('${(progress * 100).toInt()}%', style: GoogleFonts.spaceGrotesk(
                    fontSize: 16, fontWeight: FontWeight.w700, color: color)),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textTertiary),
                ),
              ]),
              const SizedBox(height: 10),
              NeonProgressBar(progress: progress, color: color, height: 4),
            ]),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: _buildTopicsList(phase, topicState, color),
          crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ]),
    ).animate().fadeIn(duration: 400.ms, delay: Duration(milliseconds: 100 * index));
  }

  Widget _buildTopicsList(Map<String, dynamic> phase, TopicNotifier topicState, Color color) {
    final topics = phase['topics'] as List;
    final phaseNum = phase['phase'] as int;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: topics.map((topic) {
          final topicName = topic['name'] as String;
          final isTopicExpanded = _expandedTopic == topicName;
          final subtopics = topicState.getSubtopics(topicName, phaseNum);
          final topicProgress = topicState.getParentProgress(topicName, phaseNum);
          return Container(
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: AppColors.card.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isTopicExpanded
                  ? color.withValues(alpha: 0.2) : Colors.transparent),
            ),
            child: Column(children: [
              InkWell(
                onTap: () => setState(() =>
                    _expandedTopic = isTopicExpanded ? null : topicName),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(children: [
                    SizedBox(width: 32, height: 32, child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: topicProgress, strokeWidth: 3,
                          strokeCap: StrokeCap.round,
                          backgroundColor: Colors.white.withValues(alpha: 0.08),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                        if (topicProgress >= 1.0)
                          Icon(Icons.check_rounded, size: 14, color: color),
                      ],
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: Text(topicName, style: AppTypography.bodyLarge)),
                    Text('${subtopics.where((s) => s.isCompleted).length}/${subtopics.length}',
                        style: AppTypography.bodySmall.copyWith(color: color)),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: isTopicExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(Icons.keyboard_arrow_down_rounded,
                          size: 20, color: AppColors.textTertiary),
                    ),
                  ]),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  children: subtopics.map((st) => _buildSubtopicItem(st, topicState, color)).toList(),
                ),
                crossFadeState: isTopicExpanded
                    ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ]),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubtopicItem(TopicModel subtopic, TopicNotifier topicState, Color color) {
    return InkWell(
      onTap: () => topicState.toggleTopic(subtopic),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(children: [
          const SizedBox(width: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 22, height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: subtopic.isCompleted ? color : Colors.transparent,
              border: Border.all(
                color: subtopic.isCompleted ? color : AppColors.textTertiary,
                width: 1.5,
              ),
            ),
            child: subtopic.isCompleted
                ? const Icon(Icons.check, size: 12, color: AppColors.background)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(subtopic.name,
              style: AppTypography.bodyMedium.copyWith(
                color: subtopic.isCompleted ? AppColors.textTertiary : AppColors.textPrimary,
                decoration: subtopic.isCompleted ? TextDecoration.lineThrough : null,
              ))),
          if (subtopic.revisionCount > 0)
            Text('🔄${subtopic.revisionCount}', style: const TextStyle(fontSize: 11)),
        ]),
      ),
    );
  }
}
