import 'package:test/test.dart';
import '../../lib/core/utils/calculators.dart';

void main() {
  group('HealthCalculators — BMI Engine', () {
    test('Standard adult male normal weight calculation', () {
      final res = HealthCalculators.calculateBmi(
        weightKg: 72.0,
        heightCm: 175.0,
        age: 26,
      );
      expect(res.bmi, equals(23.5));
      expect(res.category, equals('Normal Weight'));
      expect(res.isAdult, isTrue);
    });

    test('Overweight adult calculation', () {
      final res = HealthCalculators.calculateBmi(
        weightKg: 85.0,
        heightCm: 175.0,
        age: 30,
      );
      expect(res.bmi, equals(27.8));
      expect(res.category, equals('Overweight'));
    });

    test('Obesity Class I calculation', () {
      final res = HealthCalculators.calculateBmi(
        weightKg: 95.0,
        heightCm: 170.0,
        age: 35,
      );
      expect(res.bmi, equals(32.9));
      expect(res.category, equals('Obesity Class I'));
    });

    test('Pediatric under-18 flag and disclaimer guard', () {
      final res = HealthCalculators.calculateBmi(
        weightKg: 45.0,
        heightCm: 155.0,
        age: 14,
      );
      expect(res.isAdult, isFalse);
      expect(res.category, contains('Pediatric Percentile'));
    });

    test('Input validation for non-physiological values', () {
      expect(
        () => HealthCalculators.calculateBmi(weightKg: 10.0, heightCm: 170.0, age: 25),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => HealthCalculators.calculateBmi(weightKg: 70.0, heightCm: 40.0, age: 25),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('HealthCalculators — BMR & TDEE (Mifflin–St Jeor)', () {
    test('Male BMR calculation', () {
      // 10*72 + 6.25*175 - 5*26 + 5 = 720 + 1093.75 - 130 + 5 = 1688.75 -> 1688.8
      final bmr = HealthCalculators.calculateBmr(
        weightKg: 72.0,
        heightCm: 175.0,
        age: 26,
        gender: Gender.male,
      );
      expect(bmr, equals(1688.8));
    });

    test('Female BMR calculation', () {
      // 10*60 + 6.25*165 - 5*28 - 161 = 600 + 1031.25 - 140 - 161 = 1330.25
      final bmr = HealthCalculators.calculateBmr(
        weightKg: 60.0,
        heightCm: 165.0,
        age: 28,
        gender: Gender.female,
      );
      expect((bmr - 1330.25).abs(), lessThanOrEqualTo(0.1));
    });

    test('TDEE with Moderate Activity factor (1.55)', () {
      final tdee = HealthCalculators.calculateTdee(
        bmr: 1688.8,
        activityLevel: ActivityLevel.moderatelyActive,
      );
      // 1688.8 * 1.55 = 2617.64 -> 2617.6
      expect(tdee, equals(2617.6));
    });

    test('Calorie target with deficit and safety floor check', () {
      // Female with low TDEE
      final target = HealthCalculators.calculateCalorieTarget(
        tdee: 1400.0,
        goal: FitnessGoal.weightLoss,
        gender: Gender.female,
      );
      // Deficit would be 900, but minimum safe floor for female is 1200
      expect(target, equals(1200.0));
    });
  });

  group('HealthCalculators — Macro Split Integrity', () {
    test('Macro caloric sum matches target calories within rounding bounds', () {
      final macros = HealthCalculators.calculateMacroSplit(
        dailyCalories: 2000.0,
        weightKg: 75.0,
        goal: FitnessGoal.weightLoss,
      );
      final totalCalCalculated = macros.proteinCalories + macros.fatCalories + macros.carbsCalories;
      expect((totalCalCalculated - 2000.0).abs(), lessThanOrEqualTo(2.0));
    });
  });

  group('Unit Converters', () {
    test('kg to lbs and lbs to kg roundtrip', () {
      final lbs = HealthCalculators.kgToLbs(72.0);
      expect(lbs, equals(158.73));
      final kg = HealthCalculators.lbsToKg(lbs);
      expect(kg, equals(72.0));
    });

    test('cm to feet/inches conversion', () {
      final res = HealthCalculators.cmToFeetInches(175.0);
      expect(res.feet, equals(5));
      expect(res.inches, equals(8.9));
    });
  });
}
