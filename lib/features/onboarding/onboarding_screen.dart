import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/gradient_button.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      icon: Icons.route_rounded,
      title: 'Track Your\nCoding Journey',
      subtitle:
          'Follow a structured roadmap through Java, Spring Boot, Microservices, and DSA. Every step counts.',
      gradient: const LinearGradient(
        colors: [AppColors.neonGreen, Color(0xFF00CC6A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      emoji: '🗺️',
    ),
    _OnboardingData(
      icon: Icons.local_fire_department_rounded,
      title: 'Build\nConsistency Daily',
      subtitle:
          'Small progress every day leads to massive growth. Track your streaks, celebrate your discipline.',
      gradient: const LinearGradient(
        colors: [AppColors.electricBlue, AppColors.softPurple],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      emoji: '🔥',
    ),
    _OnboardingData(
      icon: Icons.timeline_rounded,
      title: 'Compare Yourself\nWith Yesterday',
      subtitle:
          'No competition. No overwhelm. Just you vs. your previous self. That\'s the only metric that matters.',
      gradient: const LinearGradient(
        colors: [AppColors.softPurple, AppColors.accentPink],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      emoji: '📈',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: widget.onComplete,
                child: Text(
                  'Skip',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Dots indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _currentPage == index
                          ? AppColors.neonGreen
                          : AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
            ),

            // Button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: _currentPage == _pages.length - 1
                      ? 'Get Started'
                      : 'Next',
                  icon: _currentPage == _pages.length - 1
                      ? Icons.rocket_launch_rounded
                      : Icons.arrow_forward_rounded,
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      widget.onComplete();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: data.gradient,
              boxShadow: [
                BoxShadow(
                  color: data.gradient.colors.first.withValues(alpha: 0.3),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Text(
                data.emoji,
                style: const TextStyle(fontSize: 56),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 600.ms,
                curve: Curves.elasticOut,
              ),

          const SizedBox(height: 48),

          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: 200.ms)
              .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 200.ms),

          const SizedBox(height: 16),

          // Subtitle
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: 400.ms),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final String emoji;

  _OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.emoji,
  });
}
