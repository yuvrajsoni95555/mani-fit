import 'package:flutter/material.dart';

/// MANI FIT Official Brand Colours & Semantic Design System
/// Sourced directly from official MANI FIT Brand Kit PDF
class AppColors {
  AppColors._();

  // Core Brand Palette (Exact Brand Kit Hex)
  static const Color burgundyRed = Color(0xFF8B1E3F); // Primary
  static const Color darkBurgundy = Color(0xFF5A1226); // Headers, navigation, accents
  static const Color roseGold = Color(0xFFD4A5A8); // Icons, accents, highlights
  static const Color creamWhite = Color(0xFFF8F6F4); // Backgrounds, cards, surfaces
  static const Color charcoal = Color(0xFF1A1A1A); // Text, icons, strong contrast
  static const Color slateGray = Color(0xFF6B7280); // Secondary text, borders
  static const Color lightPink = Color(0xFFF2D7DC); // Badges, subtle elements
  static const Color successGreen = Color(0xFF10B981); // Positive states, progress

  // Semantic Aliases
  static const Color primary = burgundyRed;
  static const Color background = creamWhite;
  static const Color surface = Colors.white;
  static const Color darkBackground = darkBurgundy;
  static const Color darkSurface = Color(0xFF4A1020);
  static const Color borderLight = Color(0xFFE5DEE0);
  static const Color borderDark = Color(0xFF3A0D19);

  // Gradients
  static const LinearGradient burgundyGradient = LinearGradient(
    colors: [burgundyRed, darkBurgundy],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF4A1020), darkBurgundy],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGoldGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFF3E5AB), Color(0xFFAA771C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
