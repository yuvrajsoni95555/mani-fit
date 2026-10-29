import '../constants/app_constants.dart';

enum Gender { male, female, other }

enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
  extraActive,
}

enum FitnessGoal {
  weightLoss,
  maintenance,
  muscleGain,
}

class BmiResult {
  final double bmi;
  final String category;
  final String healthRisk;
  final bool isAdult;
  final String disclaimer;

  const BmiResult({
    required this.bmi,
    required this.category,
    required this.healthRisk,
    required this.isAdult,
    required this.disclaimer,
  });
}

class MacroTargets {
  final double totalCalories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final double proteinCalories;
  final double carbsCalories;
  final double fatCalories;

  const MacroTargets({
    required this.totalCalories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.proteinCalories,
    required this.carbsCalories,
    required this.fatCalories,
  });

  Map<String, dynamic> toMap() => {
        'totalCalories': totalCalories,
        'proteinGrams': proteinGrams,
        'carbsGrams': carbsGrams,
        'fatGrams': fatGrams,
        'proteinCalories': proteinCalories,
        'carbsCalories': carbsCalories,
        'fatCalories': fatCalories,
      };
}

/// MANI FIT Deterministic Nutrition & Metabolic Calculator Engine
class HealthCalculators {
  HealthCalculators._();

  /// Calculates Body Mass Index (BMI) and provides adult clinical categorization.
  /// Throws [ArgumentError] if height or weight are non-positive or outside physiological limits.
  static BmiResult calculateBmi({
    required double weightKg,
    required double heightCm,
    required int age,
  }) {
    if (weightKg <= 20 || weightKg >= 400) {
      throw ArgumentError('Weight must be between 20kg and 400kg.');
    }
    if (heightCm <= 60 || heightCm >= 260) {
      throw ArgumentError('Height must be between 60cm and 260cm.');
    }
    if (age < 1) {
      throw ArgumentError('Age must be at least 1 year.');
    }

    final heightM = heightCm / 100.0;
    final bmi = double.parse((weightKg / (heightM * heightM)).toStringAsFixed(1));
    final isAdult = age >= 18;

    String category;
    String healthRisk;

    if (!isAdult) {
      category = 'Pediatric Percentile Assessment Required';
      healthRisk = 'Standard adult BMI classification does not apply directly to individuals under 18.';
      return BmiResult(
        bmi: bmi,
        category: category,
        healthRisk: healthRisk,
        isAdult: false,
        disclaimer: 'For children and adolescents under 18, BMI must be evaluated relative to WHO/CDC age-and-sex growth percentiles.',
      );
    }

    if (bmi < 18.5) {
      category = 'Underweight';
      healthRisk = 'Increased risk of nutritional deficiency and osteoporosis.';
    } else if (bmi < 25.0) {
      category = 'Normal Weight';
      healthRisk = 'Lowest clinical risk of weight-associated chronic diseases.';
    } else if (bmi < 30.0) {
      category = 'Overweight';
      healthRisk = 'Moderate risk of hypertension, cardiovascular disease, and metabolic changes.';
    } else if (bmi < 35.0) {
      category = 'Obesity Class I';
      healthRisk = 'High risk of type 2 diabetes, dyslipidemia, and osteoarthritis.';
    } else if (bmi < 40.0) {
      category = 'Obesity Class II';
      healthRisk = 'Very high clinical risk of cardiovascular and metabolic comorbidities.';
    } else {
      category = 'Obesity Class III';
      healthRisk = 'Extremely high risk; clinical lifestyle and medical supervision recommended.';
    }

    return BmiResult(
      bmi: bmi,
      category: category,
      healthRisk: healthRisk,
      isAdult: true,
      disclaimer: 'BMI is a general screening indicator. It does not measure body composition, muscle mass, or visceral fat distribution directly.',
    );
  }

  /// Calculates Basal Metabolic Rate (BMR) using the Mifflin–St Jeor Equation.
  /// Men: 10 * weight(kg) + 6.25 * height(cm) - 5 * age + 5
  /// Women: 10 * weight(kg) + 6.25 * height(cm) - 5 * age - 161
  static double calculateBmr({
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
  }) {
    if (weightKg <= 0 || heightCm <= 0 || age <= 0) {
      throw ArgumentError('Weight, height, and age must be strictly positive.');
    }

    final base = (10.0 * weightKg) + (6.25 * heightCm) - (5.0 * age);
    if (gender == Gender.male) {
      return double.parse((base + 5.0).toStringAsFixed(1));
    } else if (gender == Gender.female) {
      return double.parse((base - 161.0).toStringAsFixed(1));
    } else {
      // Non-binary or other: conservative intermediate average
      return double.parse((base - 78.0).toStringAsFixed(1));
    }
  }

  /// Returns the activity factor multiplier based on typical weekly physical expenditure.
  static double getActivityMultiplier(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.sedentary:
        return 1.200; // Little to no exercise, desk job
      case ActivityLevel.lightlyActive:
        return 1.375; // Light exercise 1-3 days/week
      case ActivityLevel.moderatelyActive:
        return 1.550; // Moderate exercise 3-5 days/week
      case ActivityLevel.veryActive:
        return 1.725; // Heavy exercise 6-7 days/week
      case ActivityLevel.extraActive:
        return 1.900; // Physical labor job or two-a-day training
    }
  }

  /// Calculates Total Daily Energy Expenditure (TDEE).
  static double calculateTdee({
    required double bmr,
    required ActivityLevel activityLevel,
  }) {
    if (bmr <= 0) {
      throw ArgumentError('BMR must be strictly positive.');
    }
    final multiplier = getActivityMultiplier(activityLevel);
    return double.parse((bmr * multiplier).toStringAsFixed(1));
  }

  /// Calculates recommended daily calorie target according to user goal,
  /// with safety floor protections against extreme malnutrition.
  static double calculateCalorieTarget({
    required double tdee,
    required FitnessGoal goal,
    required Gender gender,
  }) {
    double target;
    switch (goal) {
      case FitnessGoal.weightLoss:
        // Sustainable deficit: 500 kcal/day (~0.45 kg loss per week)
        target = tdee - 500.0;
        break;
      case FitnessGoal.maintenance:
        target = tdee;
        break;
      case FitnessGoal.muscleGain:
        // Controlled hypercaloric surplus: 350 kcal/day
        target = tdee + 350.0;
        break;
    }

    // Safety floor checks
    final minSafe = (gender == Gender.female)
        ? AppConstants.minSafeCaloriesFemale
        : AppConstants.minSafeCaloriesMale;

    if (target < minSafe) {
      target = minSafe;
    }

    return double.parse(target.toStringAsFixed(0));
  }

  /// Calculates evidence-based macronutrient gram targets:
  /// - Protein: 1.8g to 2.2g per kg body weight (4 kcal/g)
  /// - Fat: 25% of total energy expenditure (9 kcal/g)
  /// - Carbohydrates: Remaining energy balance (4 kcal/g)
  static MacroTargets calculateMacroSplit({
    required double dailyCalories,
    required double weightKg,
    required FitnessGoal goal,
  }) {
    if (dailyCalories <= 0 || weightKg <= 0) {
      throw ArgumentError('Calories and weight must be positive.');
    }

    // Protein target: 2.0g/kg for cutting/hypertrophy, 1.8g/kg for maintenance
    final proteinPerKg = (goal == FitnessGoal.maintenance) ? 1.8 : 2.0;
    double proteinGrams = weightKg * proteinPerKg;
    double proteinCalories = proteinGrams * 4.0;

    // Guard: Protein cannot exceed 40% of total caloric intake
    if (proteinCalories > (dailyCalories * 0.40)) {
      proteinCalories = dailyCalories * 0.35;
      proteinGrams = proteinCalories / 4.0;
    }

    // Fat target: 25% of total caloric intake
    final fatCalories = dailyCalories * 0.25;
    final fatGrams = fatCalories / 9.0;

    // Carbohydrates: Remainder
    final carbsCalories = dailyCalories - (proteinCalories + fatCalories);
    final carbsGrams = (carbsCalories > 0) ? (carbsCalories / 4.0) : 0.0;

    return MacroTargets(
      totalCalories: double.parse(dailyCalories.toStringAsFixed(0)),
      proteinGrams: double.parse(proteinGrams.toStringAsFixed(1)),
      carbsGrams: double.parse(carbsGrams.toStringAsFixed(1)),
      fatGrams: double.parse(fatGrams.toStringAsFixed(1)),
      proteinCalories: double.parse(proteinCalories.toStringAsFixed(0)),
      carbsCalories: double.parse(carbsCalories.toStringAsFixed(0)),
      fatCalories: double.parse(fatCalories.toStringAsFixed(0)),
    );
  }

  // --- Unit Conversion Utilities ---

  static double lbsToKg(double lbs) => double.parse((lbs * 0.45359237).toStringAsFixed(2));
  static double kgToLbs(double kg) => double.parse((kg / 0.45359237).toStringAsFixed(2));

  static double feetInchesToCm(int feet, double inches) {
    if (feet < 0 || inches < 0) throw ArgumentError('Measurements must be non-negative.');
    final totalInches = (feet * 12.0) + inches;
    return double.parse((totalInches * 2.54).toStringAsFixed(2));
  }

  static ({int feet, double inches}) cmToFeetInches(double cm) {
    if (cm < 0) throw ArgumentError('Centimeters must be non-negative.');
    final totalInches = cm / 2.54;
    final feet = totalInches ~/ 12;
    final remainingInches = double.parse((totalInches % 12).toStringAsFixed(1));
    return (feet: feet, inches: remainingInches);
  }
}
