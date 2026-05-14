import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/glassmorphic_card.dart';
import '../../core/widgets/neon_progress_bar.dart';
import '../../core/widgets/consistency_heatmap.dart';
import '../../providers/task_provider.dart';
import '../../providers/topic_provider.dart';
import '../../providers/dsa_provider.dart';
import '../../data/models/task_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _getRandomQuote() {
    final quotes = AppConstants.motivationalQuotes;
    return quotes[Random().nextInt(quotes.length)];
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskProvider);
    final topicState = ref.watch(topicProvider);
    final dsaState = ref.watch(dsaProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.neonGreen,
          backgroundColor: AppColors.card,
          onRefresh: () async {
            await ref.read(taskProvider).loadTasks();
            await ref.read(topicProvider).loadTopics();
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting(),
                                style: AppTypography.bodyMedium,
                              ).animate().fadeIn(duration: 400.ms),
                              const SizedBox(height: 4),
                              Text(
                                'Developer 👨‍💻',
                                style: AppTypography.heading2,
                              ).animate().fadeIn(
                                    duration: 400.ms,
                                    delay: 100.ms,
                                  ),
                            ],
                          ),
                          // Streak badge
                          _buildStreakBadge(taskState.streak),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Stats row
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _buildStatCard(
                        '🔥',
                        '${taskState.streak}',
                        'Day Streak',
                        AppColors.accentPink,
                        0,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        '✅',
                        '${taskState.completedCount}',
                        'Completed',
                        AppColors.neonGreen,
                        1,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        '🧮',
                        '${dsaState.totalSolved}',
                        'DSA Solved',
                        AppColors.electricBlue,
                        2,
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // Progress card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildProgressCard(topicState),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Motivational quote
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildQuoteCard(),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Today's tasks
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildTodayTasks(taskState),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Consistency heatmap
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassmorphicCard(
                    child: ConsistencyHeatmap(
                      activityData: taskState.activityMap,
                    ),
                  ),
                ),
              ),

              // Anti-overwhelm message
              if (taskState.overwhelmMessage != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    child: _buildAntiOverwhelmCard(
                        taskState.overwhelmMessage!),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakBadge(int streak) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accentPink.withValues(alpha: 0.2),
            AppColors.amber.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accentPink.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            '$streak day${streak != 1 ? 's' : ''}',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.accentPink,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 400.ms,
          delay: 200.ms,
        );
  }

  Widget _buildStatCard(
      String emoji, String value, String label, Color color, int index) {
    return Expanded(
      child: GlassmorphicCard(
        padding: const EdgeInsets.all(14),
        borderColor: color.withValues(alpha: 0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: AppTypography.labelSmall),
          ],
        ),
      ).animate().fadeIn(
            duration: 400.ms,
            delay: Duration(milliseconds: 200 + index * 100),
          ),
    );
  }

  Widget _buildProgressCard(TopicNotifier topicState) {
    return GlassmorphicCard(
      borderColor: AppColors.neonGreen.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall Progress', style: AppTypography.heading4),
                  const SizedBox(height: 4),
                  Text(
                    'Phase: ${topicState.currentPhaseName}',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
              CircularProgressWidget(
                progress: topicState.overallProgress,
                size: 70,
                strokeWidth: 7,
                center: Text(
                  '${(topicState.overallProgress * 100).toInt()}%',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neonGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Phase progress bars
          _buildPhaseProgress('Phase 1 — Java', topicState.phaseProgress[1] ?? 0,
              AppColors.neonGreen),
          const SizedBox(height: 8),
          _buildPhaseProgress('Phase 2 — Spring Boot',
              topicState.phaseProgress[2] ?? 0, AppColors.electricBlue),
          const SizedBox(height: 8),
          _buildPhaseProgress('Phase 3 — Microservices',
              topicState.phaseProgress[3] ?? 0, AppColors.softPurple),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 500.ms);
  }

  Widget _buildPhaseProgress(String label, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.bodySmall),
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTypography.bodySmall.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 4),
        NeonProgressBar(progress: progress, color: color, height: 6),
      ],
    );
  }

  Widget _buildQuoteCard() {
    return GlassmorphicCard(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.softPurple.withValues(alpha: 0.1),
          AppColors.electricBlue.withValues(alpha: 0.05),
        ],
      ),
      borderColor: AppColors.softPurple.withValues(alpha: 0.2),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              gradient: AppColors.purpleGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              _getRandomQuote(),
              style: AppTypography.quote,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 600.ms);
  }

  Widget _buildTodayTasks(TaskNotifier taskState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Today's Tasks", style: AppTypography.heading4),
            Text(
              '${taskState.todayTasks.where((t) => t.isCompleted).length}/${taskState.todayTasks.length}',
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.neonGreen),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (taskState.todayTasks.isEmpty)
          GlassmorphicCard(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('📝', style: TextStyle(fontSize: 32)),
                    const SizedBox(height: 8),
                    Text(
                      'No tasks for today yet',
                      style: AppTypography.bodyMedium,
                    ),
                    Text(
                      'Add tasks from the Tasks tab',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...taskState.todayTasks.asMap().entries.map((entry) {
            final index = entry.key;
            final task = entry.value;
            return _buildTaskItem(task, taskState, index);
          }),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 700.ms);
  }

  Widget _buildTaskItem(TaskModel task, TaskNotifier taskState, int index) {
    return GlassmorphicCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      borderColor: task.isCompleted
          ? AppColors.neonGreen.withValues(alpha: 0.3)
          : Colors.white.withValues(alpha: 0.05),
      onTap: () => taskState.toggleTask(task),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: task.isCompleted
                  ? AppColors.neonGreen
                  : Colors.transparent,
              border: Border.all(
                color: task.isCompleted
                    ? AppColors.neonGreen
                    : AppColors.textTertiary,
                width: 2,
              ),
            ),
            child: task.isCompleted
                ? const Icon(Icons.check, size: 14, color: AppColors.background)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: AppTypography.labelLarge.copyWith(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: task.isCompleted
                        ? AppColors.textTertiary
                        : AppColors.textPrimary,
                  ),
                ),
                if (task.description != null && task.description!.isNotEmpty)
                  Text(
                    task.description!,
                    style: AppTypography.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.cardLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${task.estimatedMinutes}m',
              style: AppTypography.labelSmall,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(
          duration: 300.ms,
          delay: Duration(milliseconds: 100 * index),
        );
  }

  Widget _buildAntiOverwhelmCard(String message) {
    return GlassmorphicCard(
      gradient: LinearGradient(
        colors: [
          AppColors.amber.withValues(alpha: 0.1),
          AppColors.accentPink.withValues(alpha: 0.05),
        ],
      ),
      borderColor: AppColors.amber.withValues(alpha: 0.3),
      child: Row(
        children: [
          const Text('🧘', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.amber,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).shake(
          hz: 1,
          offset: const Offset(2, 0),
          duration: 500.ms,
        );
  }
}
