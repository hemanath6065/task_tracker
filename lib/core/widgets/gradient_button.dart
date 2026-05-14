import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final IconData? icon;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.borderRadius = 12,
    this.padding,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                gradient: widget.gradient ?? AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonGreen.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.background,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: AppColors.background,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.text,
                          style: const TextStyle(
                            color: AppColors.background,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
