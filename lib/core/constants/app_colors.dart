import 'package:flutter/material.dart';

/// MANI FIT Official Brand Colors & Semantic Design System
class AppColors {
  AppColors._();

  // Core Brand Palette
  static const Color primaryBurgundy = Color(0xFF881E3F);
  static const Color deepBurgundy = Color(0xFF4A1226);
  static const Color roseChampagne = Color(0xFFD4A5A8);
  static const Color creamWhite = Color(0xFFF8F6F4);
  static const Color charcoal = Color(0xFF1A1A1A);
  static const Color slateGrey = Color(0xFF667280);
  static const Color lightPink = Color(0xFFF2D7DC);
  static const Color successTeal = Color(0xFF108B81);

  // Additional Functional Accents
  static const Color warningAmber = Color(0xFFE28B1B);
  static const Color errorCrimson = Color(0xFFC02A38);
  static const Color cardSurfaceLight = Color(0xFFFFFFFF);
  static const Color cardSurfaceDark = Color(0xFF242424);
  static const Color borderLight = Color(0xFFE5DEE0);
  static const Color borderDark = Color(0xFF333333);
  static const Color backgroundLight = Color(0xFFF8F6F4);
  static const Color backgroundDark = Color(0xFF141414);

  // Gradients
  static const LinearGradient burgundyGradient = LinearGradient(
    colors: [primaryBurgundy, deepBurgundy],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGoldGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFF3E5AB), Color(0xFFAA771C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
