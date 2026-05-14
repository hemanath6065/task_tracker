import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Color? borderColor;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.blur = 10,
    this.opacity = 0.1,
    this.borderColor,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              padding: padding ?? const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: gradient ??
                    LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: opacity),
                        Colors.white.withValues(alpha: opacity * 0.5),
                      ],
                    ),
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: borderColor ??
                      Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class GlowingCard extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool animate;

  const GlowingCard({
    super.key,
    required this.child,
    this.glowColor = AppColors.neonGreen,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.onTap,
    this.animate = false,
  });

  @override
  State<GlowingCard> createState() => _GlowingCardState();
}

class _GlowingCardState extends State<GlowingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.animate) {
      _controller.repeat(reverse: true);
    } else {
      _controller.value = 0.5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: widget.margin ?? const EdgeInsets.only(bottom: 12),
            padding: widget.padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: widget.glowColor
                    .withValues(alpha: widget.animate ? _animation.value * 0.5 : 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withValues(
                      alpha: widget.animate ? _animation.value * 0.15 : 0.1),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}
