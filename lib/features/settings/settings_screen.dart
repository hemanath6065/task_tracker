import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glassmorphic_card.dart';
import '../../providers/theme_provider.dart';
import '../../providers/task_provider.dart';
import '../../providers/topic_provider.dart';
import '../../providers/dsa_provider.dart';
import '../../providers/achievement_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

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
                    Text('Settings', style: AppTypography.heading2)
                        .animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 4),
                    Text('Customize your experience', style: AppTypography.bodyMedium)
                        .animate().fadeIn(duration: 400.ms, delay: 100.ms),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  // Theme toggle
                  GlassmorphicCard(
                    child: Row(children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.softPurple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.dark_mode_rounded,
                            color: AppColors.softPurple),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dark Mode', style: AppTypography.labelLarge),
                            Text('Toggle theme', style: AppTypography.bodySmall),
                          ],
                        ),
                      ),
                      Switch(
                        value: themeState.isDarkMode,
                        onChanged: (_) => ref.read(themeProvider).toggleTheme(),
                        thumbColor: WidgetStateProperty.all(AppColors.neonGreen),
                      ),
                    ]),
                  ).animate().fadeIn(duration: 300.ms, delay: 200.ms),

                  const SizedBox(height: 8),

                  // Reset onboarding
                  _buildSettingsItem(
                    icon: Icons.refresh_rounded,
                    color: AppColors.electricBlue,
                    title: 'Reset Onboarding',
                    subtitle: 'See onboarding screens again',
                    onTap: () {
                      ref.read(themeProvider).resetOnboarding();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Onboarding reset. Restart the app.')),
                      );
                    },
                  ).animate().fadeIn(duration: 300.ms, delay: 300.ms),

                  const SizedBox(height: 8),

                  // Reset progress
                  _buildSettingsItem(
                    icon: Icons.delete_forever_rounded,
                    color: AppColors.error,
                    title: 'Reset All Progress',
                    subtitle: 'Clear all data and start fresh',
                    onTap: () => _showResetDialog(context, ref),
                  ).animate().fadeIn(duration: 300.ms, delay: 400.ms),

                  const SizedBox(height: 24),

                  // App info
                  GlassmorphicCard(
                    gradient: LinearGradient(colors: [
                      AppColors.neonGreen.withValues(alpha: 0.05),
                      AppColors.electricBlue.withValues(alpha: 0.05),
                    ]),
                    borderColor: AppColors.neonGreen.withValues(alpha: 0.15),
                    child: Column(children: [
                      const Text('⚡', style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 8),
                      Text('CodeClimb', style: AppTypography.heading3),
                      const SizedBox(height: 4),
                      Text('v1.0.0', style: AppTypography.bodySmall),
                      const SizedBox(height: 8),
                      Text(
                        'Your personal developer growth OS.\nBuilt with 💚 for developers.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodySmall,
                      ),
                    ]),
                  ).animate().fadeIn(duration: 300.ms, delay: 500.ms),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GlassmorphicCard(
      onTap: onTap,
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.labelLarge),
              Text(subtitle, style: AppTypography.bodySmall),
            ],
          ),
        ),
        Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
      ]),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Reset All Progress?', style: AppTypography.heading4),
        content: Text(
          'This will permanently delete all your tasks, roadmap progress, DSA data, and achievements. This cannot be undone.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              await ref.read(taskProvider).clearAll();
              await ref.read(topicProvider).clearAll();
              await ref.read(dsaProvider).clearAll();
              await ref.read(achievementProvider).clearAll();
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All progress has been reset.')),
                );
              }
            },
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
