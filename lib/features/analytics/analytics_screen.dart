import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glassmorphic_card.dart';
import '../../core/widgets/neon_progress_bar.dart';
import '../../providers/task_provider.dart';
import '../../providers/topic_provider.dart';
import '../../providers/dsa_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskProvider);
    final topicState = ref.watch(topicProvider);
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
                    Text('Analytics', style: AppTypography.heading2)
                        .animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 4),
                    Text('Your learning insights', style: AppTypography.bodyMedium)
                        .animate().fadeIn(duration: 400.ms, delay: 100.ms),
                  ],
                ),
              ),
            ),
            // Stats cards row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  _buildMiniStat('🔥', '${taskState.streak}', 'Streak', AppColors.accentPink),
                  const SizedBox(width: 10),
                  _buildMiniStat('✅', '${taskState.completedCount}', 'Tasks', AppColors.neonGreen),
                  const SizedBox(width: 10),
                  _buildMiniStat('🧮', '${dsaState.totalSolved}', 'DSA', AppColors.electricBlue),
                  const SizedBox(width: 10),
                  _buildMiniStat('📊', '${(topicState.overallProgress * 100).toInt()}%', 'Progress', AppColors.softPurple),
                ]),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            // Weekly chart
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildWeeklyChart(taskState),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            // Phase progress
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildPhaseBreakdown(topicState),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            // Strongest / weakest
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(children: [
                  Expanded(child: _buildInsightCard(
                    '💪', 'Strongest', dsaState.strongestTopic ?? 'N/A', AppColors.neonGreen)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInsightCard(
                    '🎯', 'Focus On', dsaState.weakestTopic ?? 'N/A', AppColors.accentPink)),
                ]),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String emoji, String value, String label, Color color) {
    return Expanded(
      child: GlassmorphicCard(
        padding: const EdgeInsets.all(12),
        borderColor: color.withValues(alpha: 0.2),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 6),
          Text(value, style: GoogleFonts.spaceGrotesk(
            fontSize: 18, fontWeight: FontWeight.w700, color: color)),
          Text(label, style: AppTypography.labelSmall),
        ]),
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  Widget _buildWeeklyChart(TaskNotifier taskState) {
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    // Count tasks per day this week
    final List<double> data = List.generate(7, (i) {
      final day = weekStart.add(Duration(days: i));
      final dayKey = DateTime(day.year, day.month, day.day);
      return (taskState.activityMap[dayKey] ?? 0).toDouble();
    });

    return GlassmorphicCard(
      borderColor: AppColors.electricBlue.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('This Week', style: AppTypography.heading4),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (data.reduce((a, b) => a > b ? a : b) + 2).ceilToDouble(),
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) => Text(
                        weekDays[v.toInt()],
                        style: AppTypography.labelSmall,
                      ),
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: data.asMap().entries.map((e) {
                  return BarChartGroupData(x: e.key, barRods: [
                    BarChartRodData(
                      toY: e.value,
                      color: AppColors.electricBlue,
                      width: 20,
                      borderRadius: BorderRadius.circular(6),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: (data.reduce((a, b) => a > b ? a : b) + 2).ceilToDouble(),
                        color: Colors.white.withValues(alpha: 0.03),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }

  Widget _buildPhaseBreakdown(TopicNotifier topicState) {
    return GlassmorphicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Phase Progress', style: AppTypography.heading4),
          const SizedBox(height: 16),
          _phaseRow('Phase 1 — Java', topicState.phaseProgress[1] ?? 0, AppColors.neonGreen),
          const SizedBox(height: 10),
          _phaseRow('Phase 2 — Spring Boot', topicState.phaseProgress[2] ?? 0, AppColors.electricBlue),
          const SizedBox(height: 10),
          _phaseRow('Phase 3 — Microservices', topicState.phaseProgress[3] ?? 0, AppColors.softPurple),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 300.ms);
  }

  Widget _phaseRow(String label, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: AppTypography.bodyMedium),
          Text('${(progress * 100).toInt()}%',
              style: AppTypography.bodySmall.copyWith(color: color)),
        ]),
        const SizedBox(height: 4),
        NeonProgressBar(progress: progress, color: color, height: 6),
      ],
    );
  }

  Widget _buildInsightCard(String emoji, String label, String value, Color color) {
    return GlassmorphicCard(
      borderColor: color.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(label, style: AppTypography.labelSmall),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.labelLarge.copyWith(color: color)),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 400.ms);
  }
}
