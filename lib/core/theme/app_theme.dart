import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

/// MANI FIT Material 3 Application Theme Definition
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryBurgundy,
      scaffoldBackgroundColor: AppColors.creamWhite,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBurgundy,
        onPrimary: Colors.white,
        secondary: AppColors.roseChampagne,
        onSecondary: AppColors.charcoal,
        surface: AppColors.cardSurfaceLight,
        onSurface: AppColors.charcoal,
        error: AppColors.errorCrimson,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.deepBurgundy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headingLarge(color: Colors.white),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardSurfaceLight,
        elevation: 2,
        shadowColor: AppColors.charcoal.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBurgundy,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.buttonText(),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBurgundy,
          minimumSize: const Size.fromHeight(50),
          side: const BorderSide(color: AppColors.primaryBurgundy, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.buttonText(color: AppColors.primaryBurgundy),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBurgundy, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorCrimson),
        ),
        labelStyle: AppTypography.bodyMedium(color: AppColors.slateGrey),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryBurgundy,
        unselectedItemColor: AppColors.slateGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.roseChampagne,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.roseChampagne,
        onPrimary: AppColors.charcoal,
        secondary: AppColors.primaryBurgundy,
        onSecondary: Colors.white,
        surface: AppColors.cardSurfaceDark,
        onSurface: Colors.white,
        error: AppColors.errorCrimson,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.charcoal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headingLarge(color: Colors.white),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardSurfaceDark,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBurgundy,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.buttonText(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.roseChampagne,
          minimumSize: const Size.fromHeight(50),
          side: const BorderSide(color: AppColors.roseChampagne, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTypography.buttonText(color: AppColors.roseChampagne),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.charcoal,
        selectedItemColor: AppColors.roseChampagne,
        unselectedItemColor: AppColors.slateGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
