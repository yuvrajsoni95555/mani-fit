import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// MANI FIT Official Typography Rules
/// - Headings: Montserrat (Bold, Architectural)
/// - Body & Numeric Values: Inter (Legible, Balanced)
class AppTypography {
  AppTypography._();

  static TextStyle displayLarge({Color color = AppColors.charcoal}) =>
      GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.5,
      );

  static TextStyle displayMedium({Color color = AppColors.charcoal}) =>
      GoogleFonts.montserrat(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.3,
      );

  static TextStyle headingLarge({Color color = AppColors.charcoal}) =>
      GoogleFonts.montserrat(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle headingMedium({Color color = AppColors.charcoal}) =>
      GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle headingSmall({Color color = AppColors.charcoal}) =>
      GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle bodyLarge({Color color = AppColors.charcoal}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  static TextStyle bodyMedium({Color color = AppColors.charcoal}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.4,
      );

  static TextStyle bodySmall({Color color = AppColors.slateGrey}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle metricValue({Color color = AppColors.primaryBurgundy}) =>
      GoogleFonts.montserrat(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color,
      );

  static TextStyle buttonText({Color color = Colors.white}) =>
      GoogleFonts.montserrat(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.3,
      );
}
