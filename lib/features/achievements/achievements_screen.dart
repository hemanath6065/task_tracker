import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glassmorphic_card.dart';
import '../../providers/achievement_provider.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achieveState = ref.watch(achievementProvider);

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
                    Text('Achievements', style: AppTypography.heading2)
                        .animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 4),
                    Text(
                      '${achieveState.unlockedCount}/${achieveState.totalCount} unlocked',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.amber),
                    ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final achievement = achieveState.achievements[index];
                    final color = Color(achievement.color);
                    return GlassmorphicCard(
                      margin: EdgeInsets.zero,
                      borderColor: achievement.isUnlocked
                          ? color.withValues(alpha: 0.4)
                          : Colors.white.withValues(alpha: 0.03),
                      gradient: achievement.isUnlocked
                          ? LinearGradient(colors: [
                              color.withValues(alpha: 0.15),
                              color.withValues(alpha: 0.05),
                            ])
                          : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            achievement.icon,
                            style: TextStyle(
                              fontSize: 36,
                              color: achievement.isUnlocked ? null : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            achievement.title,
                            textAlign: TextAlign.center,
                            style: AppTypography.labelLarge.copyWith(
                              color: achievement.isUnlocked
                                  ? AppColors.textPrimary
                                  : AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            achievement.description,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodySmall.copyWith(fontSize: 10),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (achievement.isUnlocked) ...[
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('UNLOCKED',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: color, fontSize: 8, letterSpacing: 1)),
                            ),
                          ],
                        ],
                      ),
                    ).animate().fadeIn(
                      duration: 300.ms,
                      delay: Duration(milliseconds: 50 * index),
                    );
                  },
                  childCount: achieveState.achievements.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
