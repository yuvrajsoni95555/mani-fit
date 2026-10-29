import '../nutrition/models/diet_chart.dart';
import '../../core/constants/app_constants.dart';

/// MANI FIT Report & Data Export Service
class ReportGeneratorService {
  ReportGeneratorService._();

  /// Generates a clean, beautifully formatted text/markdown export of a Diet Chart
  static String generateDietChartMarkdown(DietChart chart) {
    final buffer = StringBuffer();
    buffer.writeln('# MANI FIT — DIET & NUTRITION PLAN');
    buffer.writeln('**${AppConstants.appTagline}**\n');
    buffer.writeln('---');
    buffer.writeln('### Plan: ${chart.title}');
    buffer.writeln('**Target Calories:** ${chart.targetCalories.toStringAsFixed(0)} kcal / day');
    buffer.writeln('**Dietary Pattern:** ${chart.dietaryPattern.name.toUpperCase()}');
    buffer.writeln('**Created:** ${chart.createdAt.toLocal().toString().split('.')[0]}\n');

    final totals = chart.dailyTotalNutrients;
    buffer.writeln('### Daily Nutritional Breakdown:');
    buffer.writeln('- **Calories:** ${totals.calories.toStringAsFixed(0)} kcal');
    buffer.writeln('- **Protein:** ${totals.protein.toStringAsFixed(1)} g');
    buffer.writeln('- **Carbohydrates:** ${totals.carbs.toStringAsFixed(1)} g');
    buffer.writeln('- **Healthy Fats:** ${totals.fat.toStringAsFixed(1)} g');
    buffer.writeln('- **Dietary Fiber:** ${totals.fiber.toStringAsFixed(1)} g\n');

    buffer.writeln('### Meal Schedule:');
    for (final meal in chart.meals) {
      buffer.writeln('#### ${meal.title} (${meal.recommendedTime})');
      for (final portion in meal.portions) {
        final f = portion.food;
        final n = portion.nutrients;
        buffer.writeln('  - **${f.name}** [${f.hindiName}]');
        buffer.writeln('    - Serving: ${portion.servings} x ${f.standardServingUnit} (~${portion.totalGrams.toStringAsFixed(0)}g)');
        buffer.writeln('    - Nutrients: ${n.calories} kcal | P: ${n.protein}g | C: ${n.carbs}g | F: ${n.fat}g');
      }
      final mealTotals = meal.totalNutrients;
      buffer.writeln('  *Meal Totals: ${mealTotals.calories} kcal | P: ${mealTotals.protein}g | C: ${mealTotals.carbs}g | F: ${mealTotals.fat}g*\n');
    }

    buffer.writeln('### Consolidated Grocery Shopping List:');
    final groceryList = chart.generateGroceryList();
    groceryList.forEach((item, amount) {
      buffer.writeln('- [ ] **$item**: $amount');
    });

    buffer.writeln('\n---');
    buffer.writeln('*Clinical Disclaimer:*');
    buffer.writeln(AppConstants.medicalDisclaimer);

    return buffer.toString();
  }

  /// Exports all user data into a structured JSON for GDPR / personal data portability compliance
  static Map<String, dynamic> exportPersonalUserData({
    required String uid,
    required String email,
    required Map<String, dynamic> profile,
    required List<Map<String, dynamic>> dietCharts,
    required List<Map<String, dynamic>> workoutLogs,
    required List<Map<String, dynamic>> hydrationLogs,
  }) {
    return {
      'maniFitExportVersion': '1.0',
      'exportTimestamp': DateTime.now().toIso8601String(),
      'user': {
        'uid': uid,
        'email': email,
        'profile': profile,
      },
      'dietCharts': dietCharts,
      'workoutLogs': workoutLogs,
      'hydrationLogs': hydrationLogs,
      'privacyStatement': 'This file contains your personal data exported directly from MANI FIT. Store securely.',
    };
  }
}
