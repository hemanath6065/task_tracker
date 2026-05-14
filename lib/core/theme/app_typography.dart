import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextStyle get heading1 => GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle get heading2 => GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.3,
      );

  static TextStyle get heading3 => GoogleFonts.spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get heading4 => GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textTertiary,
        letterSpacing: 0.8,
      );

  static TextStyle get button => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.background,
        letterSpacing: 0.3,
      );

  static TextStyle get caption => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get code => GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.neonGreen,
      );

  static TextStyle get streak => GoogleFonts.spaceGrotesk(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: AppColors.neonGreen,
        letterSpacing: -1,
      );

  static TextStyle get quote => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        fontStyle: FontStyle.italic,
        height: 1.6,
      );
}
