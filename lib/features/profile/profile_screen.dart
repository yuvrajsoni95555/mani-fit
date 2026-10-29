import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/calculators.dart';
import '../nutrition/models/food_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Editable Profile Biometrics
  int _age = 26;
  double _heightCm = 175.0;
  double _weightKg = 72.0;
  Gender _gender = Gender.male;
  ActivityLevel _activityLevel = ActivityLevel.moderatelyActive;
  FitnessGoal _fitnessGoal = FitnessGoal.weightLoss;
  DietaryType _dietaryPattern = DietaryType.vegetarian;

  // Calculators
  BmiResult get _bmi => HealthCalculators.calculateBmi(
        weightKg: _weightKg,
        heightCm: _heightCm,
        age: _age,
      );

  double get _bmr => HealthCalculators.calculateBmr(
        weightKg: _weightKg,
        heightCm: _heightCm,
        age: _age,
        gender: _gender,
      );

  double get _tdee => HealthCalculators.calculateTdee(
        bmr: _bmr,
        activityLevel: _activityLevel,
      );

  double get _calorieTarget => HealthCalculators.calculateCalorieTarget(
        tdee: _tdee,
        goal: _fitnessGoal,
        gender: _gender,
      );

  MacroTargets get _macros => HealthCalculators.calculateMacroSplit(
        dailyCalories: _calorieTarget,
        weightKg: _weightKg,
        goal: _fitnessGoal,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile & Metabolic Health', style: AppTypography.headingLarge(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primaryBurgundy,
                  child: const Text('MF', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Yuvraj Soni', style: AppTypography.headingLarge()),
                    Text('Active Member • MANI FIT Athlete', style: AppTypography.bodySmall(color: AppColors.slateGrey)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.lightPink,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Sync: Local & Cloud Ready',
                        style: AppTypography.bodySmall(color: AppColors.deepBurgundy).copyWith(fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Live Metabolic Engine Results Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.burgundyGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBurgundy.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CALCULATED METABOLIC METRICS',
                    style: AppTypography.bodySmall(color: AppColors.roseChampagne).copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetricItem('BMI', '${_bmi.bmi}', _bmi.category),
                      _buildMetricItem('BMR', '${_bmr.toInt()} kcal', 'Mifflin-St Jeor'),
                      _buildMetricItem('TDEE', '${_tdee.toInt()} kcal', 'Daily Burn'),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Target Calories', style: AppTypography.bodySmall(color: Colors.white70)),
                          Text('${_calorieTarget.toInt()} kcal', style: AppTypography.headingLarge(color: Colors.white)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Target Macros', style: AppTypography.bodySmall(color: Colors.white70)),
                          Text(
                            'P: ${_macros.proteinGrams.toInt()}g | C: ${_macros.carbsGrams.toInt()}g | F: ${_macros.fatGrams.toInt()}g',
                            style: AppTypography.bodyMedium(color: AppColors.roseChampagne).copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Interactive Profile Biometrics Editor
            Text('Adjust Biometrics', style: AppTypography.headingLarge()),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Weight Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Current Weight', style: AppTypography.bodyLarge()),
                        Text('${_weightKg.toStringAsFixed(1)} kg', style: AppTypography.headingSmall(color: AppColors.primaryBurgundy)),
                      ],
                    ),
                    Slider(
                      value: _weightKg,
                      min: 35,
                      max: 180,
                      divisions: 290,
                      activeColor: AppColors.primaryBurgundy,
                      onChanged: (val) => setState(() => _weightKg = val),
                    ),
                    const SizedBox(height: 8),

                    // Height Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Height', style: AppTypography.bodyLarge()),
                        Text('${_heightCm.toInt()} cm', style: AppTypography.headingSmall(color: AppColors.primaryBurgundy)),
                      ],
                    ),
                    Slider(
                      value: _heightCm,
                      min: 120,
                      max: 220,
                      divisions: 100,
                      activeColor: AppColors.primaryBurgundy,
                      onChanged: (val) => setState(() => _heightCm = val),
                    ),
                    const SizedBox(height: 8),

                    // Age Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Age', style: AppTypography.bodyLarge()),
                        Text('$_age years', style: AppTypography.headingSmall(color: AppColors.primaryBurgundy)),
                      ],
                    ),
                    Slider(
                      value: _age.toDouble(),
                      min: 14,
                      max: 90,
                      divisions: 76,
                      activeColor: AppColors.primaryBurgundy,
                      onChanged: (val) => setState(() => _age = val.toInt()),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Fitness Goal Selector
            Text('Primary Fitness Goal', style: AppTypography.headingSmall()),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: FitnessGoal.values.map((goal) {
                final isSelected = _fitnessGoal == goal;
                return ChoiceChip(
                  label: Text(goal == FitnessGoal.weightLoss
                      ? 'Weight Loss (Deficit)'
                      : goal == FitnessGoal.maintenance
                          ? 'Maintenance'
                          : 'Muscle Gain (Surplus)'),
                  selected: isSelected,
                  selectedColor: AppColors.primaryBurgundy,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _fitnessGoal = goal);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, String sub) {
    return Column(
      children: [
        Text(label, style: AppTypography.bodySmall(color: Colors.white70)),
        Text(value, style: AppTypography.headingMedium(color: Colors.white)),
        Text(sub, style: AppTypography.bodySmall(color: AppColors.roseChampagne).copyWith(fontSize: 10)),
      ],
    );
  }
}
