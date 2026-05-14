import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3500), widget.onComplete);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              Color(0xFF0D1225),
              AppColors.background,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              _buildLogo()
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                    duration: 800.ms,
                    delay: 200.ms,
                    curve: Curves.elasticOut,
                  ),

              const SizedBox(height: 24),

              // App name
              Text(
                'CodeClimb',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 600.ms)
                  .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 600.ms),

              const SizedBox(height: 8),

              // Tagline
              Text(
                'Your Developer Growth OS',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 1000.ms),

              const SizedBox(height: 48),

              // Quote
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  '"Small progress every day."',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: AppColors.neonGreen.withValues(alpha: 0.8),
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 1600.ms),

              const SizedBox(height: 64),

              // Loading indicator
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.neonGreen.withValues(alpha: 0.6),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 2200.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.neonGreen,
            AppColors.electricBlue,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonGreen.withValues(alpha: 0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Code brackets
            Text(
              '</>',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.background,
              ),
            ),
            // Upward arrow
            Positioned(
              top: 16,
              child: Icon(
                Icons.arrow_upward_rounded,
                color: AppColors.background.withValues(alpha: 0.5),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
