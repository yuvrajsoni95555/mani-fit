import '../../core/utils/calculators.dart';
import '../nutrition/models/food_item.dart';
import '../subscription/subscription_models.dart';

class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final int age;
  final double heightCm;
  final double weightKg;
  final Gender gender;
  final ActivityLevel activityLevel;
  final FitnessGoal goal;
  final DietaryType dietaryPattern;
  final List<String> allergies;
  final double? targetWeightKg;
  final UserSubscription subscription;
  final bool isGuest;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.gender,
    required this.activityLevel,
    required this.goal,
    required this.dietaryPattern,
    this.allergies = const [],
    this.targetWeightKg,
    this.subscription = const UserSubscription(tier: SubscriptionTier.free),
    this.isGuest = false,
  });

  BmiResult get bmiResult => HealthCalculators.calculateBmi(
        weightKg: weightKg,
        heightCm: heightCm,
        age: age,
      );

  double get bmr => HealthCalculators.calculateBmr(
        weightKg: weightKg,
        heightCm: heightCm,
        age: age,
        gender: gender,
      );

  double get tdee => HealthCalculators.calculateTdee(
        bmr: bmr,
        activityLevel: activityLevel,
      );

  double get dailyCalorieTarget => HealthCalculators.calculateCalorieTarget(
        tdee: tdee,
        goal: goal,
        gender: gender,
      );

  MacroTargets get macroTargets => HealthCalculators.calculateMacroSplit(
        dailyCalories: dailyCalorieTarget,
        weightKg: weightKg,
        goal: goal,
      );

  UserProfile copyWith({
    String? uid,
    String? email,
    String? displayName,
    int? age,
    double? heightCm,
    double? weightKg,
    Gender? gender,
    ActivityLevel? activityLevel,
    FitnessGoal? goal,
    DietaryType? dietaryPattern,
    List<String>? allergies,
    double? targetWeightKg,
    UserSubscription? subscription,
    bool? isGuest,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      dietaryPattern: dietaryPattern ?? this.dietaryPattern,
      allergies: allergies ?? this.allergies,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      subscription: subscription ?? this.subscription,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'age': age,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'gender': gender.name,
        'activityLevel': activityLevel.name,
        'goal': goal.name,
        'dietaryPattern': dietaryPattern.name,
        'allergies': allergies,
        'targetWeightKg': targetWeightKg,
        'subscription': subscription.toMap(),
        'isGuest': isGuest,
        'metrics': {
          'bmi': bmiResult.bmi,
          'bmiCategory': bmiResult.category,
          'bmr': bmr,
          'tdee': tdee,
          'dailyCalorieTarget': dailyCalorieTarget,
          'macros': macroTargets.toMap(),
        },
      };

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String,
      email: (map['email'] as String?) ?? '',
      displayName: (map['displayName'] as String?) ?? 'MANI FIT User',
      age: (map['age'] as num).toInt(),
      heightCm: (map['heightCm'] as num).toDouble(),
      weightKg: (map['weightKg'] as num).toDouble(),
      gender: Gender.values.firstWhere((e) => e.name == map['gender'], orElse: () => Gender.male),
      activityLevel: ActivityLevel.values.firstWhere((e) => e.name == map['activityLevel'], orElse: () => ActivityLevel.moderatelyActive),
      goal: FitnessGoal.values.firstWhere((e) => e.name == map['goal'], orElse: () => FitnessGoal.weightLoss),
      dietaryPattern: DietaryType.values.firstWhere((e) => e.name == map['dietaryPattern'], orElse: () => DietaryType.vegetarian),
      allergies: List<String>.from(map['allergens'] ?? []),
      targetWeightKg: (map['targetWeightKg'] as num?)?.toDouble(),
      subscription: map['subscription'] != null
          ? UserSubscription.fromMap(Map<String, dynamic>.from(map['subscription']))
          : const UserSubscription(tier: SubscriptionTier.free),
      isGuest: (map['isGuest'] as bool?) ?? false,
    );
  }
}
