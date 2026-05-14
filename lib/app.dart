import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_colors.dart';
import 'features/home/home_screen.dart';
import 'features/roadmap/roadmap_screen.dart';
import 'features/daily_tasks/daily_tasks_screen.dart';
import 'features/dsa_tracker/dsa_tracker_screen.dart';
import 'features/analytics/analytics_screen.dart';
import 'features/achievements/achievements_screen.dart';
import 'features/settings/settings_screen.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    RoadmapScreen(),
    DailyTasksScreen(),
    DsaTrackerScreen(),
    AnalyticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Home'),
                _buildNavItem(1, Icons.route_rounded, 'Roadmap'),
                _buildNavItem(2, Icons.task_alt_rounded, 'Tasks'),
                _buildNavItem(3, Icons.code_rounded, 'DSA'),
                _buildNavItem(4, Icons.insights_rounded, 'Stats'),
              ],
            ),
          ),
        ),
      ),
      // Drawer for settings & achievements
      endDrawer: Drawer(
        backgroundColor: AppColors.surface,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text('</>',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.background,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('CodeClimb',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.cardLight),
              _buildDrawerItem(Icons.emoji_events_rounded, 'Achievements',
                  AppColors.amber, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AchievementsScreen()),
                );
              }),
              _buildDrawerItem(Icons.settings_rounded, 'Settings',
                  AppColors.textSecondary, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SettingsScreen()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.neonGreen.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppColors.neonGreen : AppColors.textTertiary,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.neonGreen : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title,
          style: GoogleFonts.inter(color: AppColors.textPrimary)),
      onTap: onTap,
    );
  }
}
