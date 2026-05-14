import 'package:flutter/material.dart';

class AppColors {
  // Primary backgrounds
  static const Color background = Color(0xFF0A0E1A);
  static const Color surface = Color(0xFF121828);
  static const Color card = Color(0xFF1A2035);
  static const Color cardLight = Color(0xFF222842);

  // Accent colors
  static const Color neonGreen = Color(0xFF00FF88);
  static const Color electricBlue = Color(0xFF4D9EFF);
  static const Color softPurple = Color(0xFF8B5CF6);
  static const Color accentPink = Color(0xFFFF6B9D);
  static const Color amber = Color(0xFFFFB340);
  static const Color cyan = Color(0xFF22D3EE);

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8892B0);
  static const Color textTertiary = Color(0xFF5A6380);

  // Status colors
  static const Color success = Color(0xFF00FF88);
  static const Color warning = Color(0xFFFFB340);
  static const Color error = Color(0xFFFF4757);
  static const Color info = Color(0xFF4D9EFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [neonGreen, electricBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [softPurple, electricBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [background, surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A2035), Color(0xFF151D30)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGlow = LinearGradient(
    colors: [Color(0xFF00FF88), Color(0xFF00CC6A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light theme colors
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF0F2F5);
  static const Color lightTextPrimary = Color(0xFF1A1A2E);
  static const Color lightTextSecondary = Color(0xFF6B7280);
}
