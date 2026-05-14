import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/roadmap_data.dart';
import '../../core/widgets/glassmorphic_card.dart';
import '../../core/widgets/neon_progress_bar.dart';
import '../../providers/dsa_provider.dart';

class DsaTrackerScreen extends ConsumerStatefulWidget {
  const DsaTrackerScreen({super.key});
  @override
  ConsumerState<DsaTrackerScreen> createState() => _DsaTrackerScreenState();
}

class _DsaTrackerScreenState extends ConsumerState<DsaTrackerScreen> {
  String? _expandedTopic;

  @override
  Widget build(BuildContext context) {
    final dsaState = ref.watch(dsaProvider);
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
                    Text('DSA Tracker', style: AppTypography.heading2)
                        .animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 4),
                    Text('${dsaState.totalSolved} problems solved',
                        style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.neonGreen))
                        .animate().fadeIn(duration: 400.ms, delay: 100.ms),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final topic = RoadmapData.dsaTopics[index];
                final topicName = topic['name'] as String;
                final color = Color(topic['color'] as int);
                final icon = topic['icon'] as String;
                final isExpanded = _expandedTopic == topicName;
                final solved = dsaState.getSolvedCountForTopic(topicName);
                final total = dsaState.getTotalCountForTopic(topicName);
                final progress = total > 0 ? solved / total : 0.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: GlassmorphicCard(
                    padding: EdgeInsets.zero,
                    borderColor: isExpanded
                        ? color.withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.05),
                    child: Column(children: [
                      InkWell(
                        onTap: () => setState(() =>
                            _expandedTopic = isExpanded ? null : topicName),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(child: Text(icon, style: const TextStyle(fontSize: 20))),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(topicName, style: AppTypography.labelLarge),
                                  const SizedBox(height: 4),
                                  NeonProgressBar(progress: progress, color: color, height: 4),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('$solved/$total',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 14, fontWeight: FontWeight.w700, color: color)),
                            const SizedBox(width: 4),
                            AnimatedRotation(
                              turns: isExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.textTertiary, size: 20),
                            ),
                          ]),
                        ),
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: _buildProblemsList(dsaState, topicName, color),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 200),
                      ),
                    ]),
                  ).animate().fadeIn(duration: 300.ms, delay: Duration(milliseconds: 50 * index)),
                );
              }, childCount: RoadmapData.dsaTopics.length),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemsList(DsaNotifier dsaState, String topic, Color color) {
    final problems = dsaState.getProblemsByTopic(topic);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        children: problems.map((problem) => InkWell(
          onTap: () => dsaState.toggleSolved(problem),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 22, height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: problem.isSolved ? color : Colors.transparent,
                  border: Border.all(
                    color: problem.isSolved ? color : AppColors.textTertiary,
                    width: 1.5,
                  ),
                ),
                child: problem.isSolved
                    ? const Icon(Icons.check, size: 12, color: AppColors.background)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(problem.name,
                    style: AppTypography.bodyMedium.copyWith(
                      color: problem.isSolved ? AppColors.textTertiary : AppColors.textPrimary,
                      decoration: problem.isSolved ? TextDecoration.lineThrough : null,
                    )),
              ),
              if (problem.revisionCount > 0)
                Text('🔄${problem.revisionCount}', style: const TextStyle(fontSize: 11)),
            ]),
          ),
        )).toList(),
      ),
    );
  }
}
