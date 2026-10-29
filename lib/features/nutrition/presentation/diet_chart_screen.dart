import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../models/food_item.dart';
import '../models/diet_chart.dart';
import '../services/nutrition_engine.dart';
import '../../reports/report_generator_service.dart';

class DietChartScreen extends StatefulWidget {
  const DietChartScreen({super.key});

  @override
  State<DietChartScreen> createState() => _DietChartScreenState();
}

class _DietChartScreenState extends State<DietChartScreen> {
  double _calorieTarget = 1950.0;
  DietaryType _dietaryPattern = DietaryType.vegetarian;
  final List<String> _selectedAllergens = [];

  late DietChart _currentChart;

  @override
  void initState() {
    super.initState();
    _regenerateChart();
  }

  void _regenerateChart() {
    setState(() {
      _currentChart = NutritionEngine.generateDietChart(
        id: 'dc_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Personalized ${_dietaryPattern.name.toUpperCase()} Plan',
        targetCalories: _calorieTarget,
        dietaryPattern: _dietaryPattern,
        excludedAllergens: _selectedAllergens,
      );
    });
  }

  void _updatePortion(int mealIndex, int portionIndex, double delta) {
    setState(() {
      final meal = _currentChart.meals[mealIndex];
      final portion = meal.portions[portionIndex];
      final newServings = (portion.servings + delta).clamp(0.5, 8.0);

      final updatedPortions = List<MealPortion>.from(meal.portions);
      updatedPortions[portionIndex] = portion.copyWith(servings: newServings);

      final updatedMeals = List<PlannedMeal>.from(_currentChart.meals);
      updatedMeals[mealIndex] = meal.copyWithPortions(updatedPortions);

      _currentChart = DietChart(
        id: _currentChart.id,
        title: _currentChart.title,
        description: _currentChart.description,
        targetCalories: _currentChart.targetCalories,
        dietaryPattern: _currentChart.dietaryPattern,
        excludedAllergens: _currentChart.excludedAllergens,
        meals: updatedMeals,
        createdAt: _currentChart.createdAt,
        isCustomized: true,
      );
    });
  }

  void _showGroceryListModal() {
    final list = _currentChart.generateGroceryList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Grocery Shopping List', style: AppTypography.headingLarge()),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Text(
                    'Aggregated ingredient quantities for your active meal plan.',
                    style: AppTypography.bodySmall(color: AppColors.slateGrey),
                  ),
                  const Divider(height: 24),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final entry = list.entries.elementAt(index);
                        return CheckboxListTile(
                          value: false,
                          onChanged: (_) {},
                          title: Text(entry.key, style: AppTypography.bodyLarge()),
                          subtitle: Text('Required: ${entry.value}', style: AppTypography.bodySmall(color: AppColors.primaryBurgundy)),
                          activeColor: AppColors.primaryBurgundy,
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _exportPlan() {
    final markdown = ReportGeneratorService.generateDietChartMarkdown(_currentChart);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.share, color: AppColors.primaryBurgundy),
            const SizedBox(width: 8),
            Text('Export Diet Chart', style: AppTypography.headingMedium()),
          ],
        ),
        content: SingleChildScrollView(
          child: SelectableText(
            markdown,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Diet plan formatted text copied to clipboard!'),
                  backgroundColor: AppColors.successTeal,
                ),
              );
            },
            child: const Text('Copy Plan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dailyTotals = _currentChart.dailyTotalNutrients;

    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Chart Maker', style: AppTypography.headingLarge(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            tooltip: 'Grocery List',
            onPressed: _showGroceryListModal,
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Export Plan',
            onPressed: _exportPlan,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Controls Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Target Calories', style: AppTypography.headingMedium()),
                        Text(
                          '${_calorieTarget.toInt()} kcal',
                          style: AppTypography.headingMedium(color: AppColors.primaryBurgundy),
                        ),
                      ],
                    ),
                    Slider(
                      value: _calorieTarget,
                      min: 1200,
                      max: 3500,
                      divisions: 46,
                      activeColor: AppColors.primaryBurgundy,
                      inactiveColor: AppColors.lightPink,
                      onChanged: (val) {
                        setState(() => _calorieTarget = val);
                      },
                      onChangeEnd: (_) => _regenerateChart(),
                    ),
                    const SizedBox(height: 12),

                    // Dietary Pattern Filter
                    Text('Dietary Preference', style: AppTypography.headingSmall()),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: DietaryType.values.map((type) {
                        final isSelected = _dietaryPattern == type;
                        return ChoiceChip(
                          label: Text(type.name.toUpperCase()),
                          selected: isSelected,
                          selectedColor: AppColors.primaryBurgundy,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.charcoal,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _dietaryPattern = type);
                              _regenerateChart();
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Live Calculated Daily Totals Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.burgundyGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryNutrient('Calories', '${dailyTotals.calories.toInt()} kcal', Colors.white),
                  _buildSummaryNutrient('Protein', '${dailyTotals.protein}g', AppColors.roseChampagne),
                  _buildSummaryNutrient('Carbs', '${dailyTotals.carbs}g', AppColors.lightPink),
                  _buildSummaryNutrient('Fats', '${dailyTotals.fat}g', Colors.white70),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Meals List
            Text('Scheduled Meals', style: AppTypography.headingLarge()),
            const SizedBox(height: 12),

            ...List.generate(_currentChart.meals.length, (mealIndex) {
              final meal = _currentChart.meals[mealIndex];
              final mealNutrients = meal.totalNutrients;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.lightPink,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.alarm, size: 16, color: AppColors.primaryBurgundy),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(meal.title, style: AppTypography.headingSmall()),
                                  Text(meal.recommendedTime, style: AppTypography.bodySmall()),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            '${mealNutrients.calories.toInt()} kcal',
                            style: AppTypography.headingSmall(color: AppColors.primaryBurgundy),
                          ),
                        ],
                      ),
                      const Divider(height: 20),

                      // Portions
                      ...List.generate(meal.portions.length, (portionIndex) {
                        final portion = meal.portions[portionIndex];
                        final food = portion.food;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${food.name} ${food.hindiName.isNotEmpty ? "(${food.hindiName})" : ""}',
                                      style: AppTypography.bodyLarge().copyWith(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '${portion.totalGrams.toInt()}g | P: ${portion.nutrients.protein}g, C: ${portion.nutrients.carbs}g, F: ${portion.nutrients.fat}g',
                                      style: AppTypography.bodySmall(color: AppColors.slateGrey),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, size: 20, color: AppColors.slateGrey),
                                    onPressed: () => _updatePortion(mealIndex, portionIndex, -0.5),
                                  ),
                                  Text(
                                    '${portion.servings}x',
                                    style: AppTypography.bodyMedium().copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, size: 20, color: AppColors.primaryBurgundy),
                                    onPressed: () => _updatePortion(mealIndex, portionIndex, 0.5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 12),
            // Clinical Disclaimer Notice
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.borderLight.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 20, color: AppColors.slateGrey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppConstants.medicalDisclaimer,
                      style: AppTypography.bodySmall(color: AppColors.slateGrey).copyWith(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryNutrient(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: AppTypography.headingSmall(color: color)),
        Text(label, style: AppTypography.bodySmall(color: Colors.white70).copyWith(fontSize: 11)),
      ],
    );
  }
}
