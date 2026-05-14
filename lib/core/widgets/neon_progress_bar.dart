import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NeonProgressBar extends StatelessWidget {
  final double progress;
  final Color color;
  final Color? backgroundColor;
  final double height;
  final double borderRadius;
  final bool showPercentage;
  final bool animate;

  const NeonProgressBar({
    super.key,
    required this.progress,
    this.color = AppColors.neonGreen,
    this.backgroundColor,
    this.height = 8,
    this.borderRadius = 4,
    this.showPercentage = false,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (showPercentage)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: animate
                        ? const Duration(milliseconds: 800)
                        : Duration.zero,
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color,
                          color.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class CircularProgressWidget extends StatelessWidget {
  final double progress;
  final double size;
  final Color color;
  final Color? backgroundColor;
  final double strokeWidth;
  final Widget? center;

  const CircularProgressWidget({
    super.key,
    required this.progress,
    this.size = 120,
    this.color = AppColors.neonGreen,
    this.backgroundColor,
    this.strokeWidth = 10,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow effect
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: strokeWidth,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation<Color>(
                backgroundColor ?? Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          // Progress circle
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              );
            },
          ),
          // Center content
          ?center,
        ],
      ),
    );
  }
}
