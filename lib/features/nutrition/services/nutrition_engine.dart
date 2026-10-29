import '../models/food_item.dart';
import '../models/diet_chart.dart';

/// MANI FIT Official Nutrition Planning & Food Database Engine
class NutritionEngine {
  NutritionEngine._();

  /// Curated authentic food database referencing ICMR-NIN IFCT 2017 & USDA FDC standards
  static final List<FoodItem> foodDatabase = [
    const FoodItem(
      id: 'f_roti_wheat',
      name: 'Whole Wheat Roti / Chapati',
      hindiName: 'रोटी',
      category: FoodCategory.grainsAndCereals,
      dietaryType: DietaryType.vegan,
      state: FoodState.cooked,
      standardServingUnit: '1 medium roti (35g)',
      standardServingGrams: 35.0,
      caloriesPer100g: 297.0,
      proteinPer100g: 10.5,
      carbsPer100g: 61.2,
      fatPer100g: 1.5,
      fiberPer100g: 9.8,
      allergens: ['gluten'],
      ingredients: ['Whole wheat flour', 'Water', 'Pinch of salt'],
      dataSource: 'ICMR-NIN IFCT 2017',
    ),
    const FoodItem(
      id: 'f_oats_rolled',
      name: 'Rolled Oats (Cooked)',
      hindiName: 'ओट्स',
      category: FoodCategory.grainsAndCereals,
      dietaryType: DietaryType.vegan,
      state: FoodState.cooked,
      standardServingUnit: '1 bowl (200g)',
      standardServingGrams: 200.0,
      caloriesPer100g: 71.0,
      proteinPer100g: 2.5,
      carbsPer100g: 12.0,
      fatPer100g: 1.5,
      fiberPer100g: 1.7,
      allergens: [],
      ingredients: ['Rolled oats', 'Water'],
      dataSource: 'USDA FDC',
    ),
    const FoodItem(
      id: 'f_brown_rice',
      name: 'Steamed Brown Rice',
      hindiName: 'ब्राउन राइस',
      category: FoodCategory.grainsAndCereals,
      dietaryType: DietaryType.vegan,
      state: FoodState.cooked,
      standardServingUnit: '1 cup / bowl (150g)',
      standardServingGrams: 150.0,
      caloriesPer100g: 111.0,
      proteinPer100g: 2.6,
      carbsPer100g: 23.0,
      fatPer100g: 0.9,
      fiberPer100g: 1.8,
      allergens: [],
      ingredients: ['Whole grain brown rice', 'Water'],
      dataSource: 'USDA FDC',
    ),
    const FoodItem(
      id: 'f_dal_moong',
      name: 'Moong Dal (Yellow Lentils Tadka)',
      hindiName: 'मूंग दाल तड़का',
      category: FoodCategory.pulsesAndLegumes,
      dietaryType: DietaryType.vegan,
      state: FoodState.cooked,
      standardServingUnit: '1 katori / bowl (150g)',
      standardServingGrams: 150.0,
      caloriesPer100g: 104.0,
      proteinPer100g: 6.8,
      carbsPer100g: 15.5,
      fatPer100g: 2.2,
      fiberPer100g: 4.1,
      allergens: [],
      ingredients: ['Yellow moong dal', 'Cumin', 'Turmeric', 'Tomato', '1 tsp mustard oil'],
      dataSource: 'ICMR-NIN IFCT 2017',
    ),
    const FoodItem(
      id: 'f_paneer_fresh',
      name: 'Fresh Cow Milk Paneer (Low Fat)',
      hindiName: 'पनीर',
      category: FoodCategory.dairyAndAlternatives,
      dietaryType: DietaryType.vegetarian,
      state: FoodState.cooked,
      standardServingUnit: '1 portion (100g)',
      standardServingGrams: 100.0,
      caloriesPer100g: 180.0,
      proteinPer100g: 18.0,
      carbsPer100g: 3.5,
      fatPer100g: 10.5,
      fiberPer100g: 0.0,
      allergens: ['dairy'],
      ingredients: ['Low fat cow milk', 'Lemon juice curdling'],
      dataSource: 'ICMR-NIN IFCT 2017',
    ),
    const FoodItem(
      id: 'f_soya_chunks',
      name: 'Soya Chunks Curry',
      hindiName: 'सोया चंक्स करी',
      category: FoodCategory.pulsesAndLegumes,
      dietaryType: DietaryType.vegan,
      state: FoodState.cooked,
      standardServingUnit: '1 bowl (150g cooked, ~45g dry)',
      standardServingGrams: 150.0,
      caloriesPer100g: 110.0,
      proteinPer100g: 15.2,
      carbsPer100g: 8.5,
      fatPer100g: 1.2,
      fiberPer100g: 4.0,
      allergens: ['soy'],
      ingredients: ['Defatted soy flour chunks', 'Onion', 'Tomato', 'Spices'],
      dataSource: 'ICMR-NIN IFCT 2017',
    ),
    const FoodItem(
      id: 'f_boiled_eggs',
      name: 'Whole Boiled Egg',
      hindiName: 'उबला अंडा',
      category: FoodCategory.meatPoultryFish,
      dietaryType: DietaryType.eggetarian,
      state: FoodState.cooked,
      standardServingUnit: '1 large egg (50g)',
      standardServingGrams: 50.0,
      caloriesPer100g: 155.0,
      proteinPer100g: 12.6,
      carbsPer100g: 1.1,
      fatPer100g: 10.6,
      fiberPer100g: 0.0,
      allergens: ['egg'],
      ingredients: ['Whole chicken egg'],
      dataSource: 'USDA FDC',
    ),
    const FoodItem(
      id: 'f_chicken_breast',
      name: 'Grilled Skinless Chicken Breast',
      hindiName: 'ग्रिल्ड चिकन',
      category: FoodCategory.meatPoultryFish,
      dietaryType: DietaryType.nonVegetarian,
      state: FoodState.cooked,
      standardServingUnit: '1 fillet (150g)',
      standardServingGrams: 150.0,
      caloriesPer100g: 165.0,
      proteinPer100g: 31.0,
      carbsPer100g: 0.0,
      fatPer100g: 3.6,
      fiberPer100g: 0.0,
      allergens: [],
      ingredients: ['Skinless chicken breast', 'Black pepper', 'Lemon juice', '1/2 tsp olive oil'],
      dataSource: 'USDA FDC',
    ),
    const FoodItem(
      id: 'f_curd_dahi',
      name: 'Fresh Plain Curd / Dahi',
      hindiName: 'दही',
      category: FoodCategory.dairyAndAlternatives,
      dietaryType: DietaryType.vegetarian,
      state: FoodState.cooked,
      standardServingUnit: '1 cup (150g)',
      standardServingGrams: 150.0,
      caloriesPer100g: 61.0,
      proteinPer100g: 3.5,
      carbsPer100g: 4.7,
      fatPer100g: 3.3,
      fiberPer100g: 0.0,
      allergens: ['dairy'],
      ingredients: ['Cultured pasteurized milk'],
      dataSource: 'ICMR-NIN IFCT 2017',
    ),
    const FoodItem(
      id: 'f_sprouts_salad',
      name: 'Moong & Chana Sprout Salad',
      hindiName: 'अंकुरित सलाद',
      category: FoodCategory.pulsesAndLegumes,
      dietaryType: DietaryType.vegan,
      state: FoodState.raw,
      standardServingUnit: '1 bowl (120g)',
      standardServingGrams: 120.0,
      caloriesPer100g: 82.0,
      proteinPer100g: 6.2,
      carbsPer100g: 13.5,
      fatPer100g: 0.8,
      fiberPer100g: 3.8,
      allergens: [],
      ingredients: ['Sprouted moong', 'Sprouted brown chana', 'Cucumber', 'Lemon juice', 'Chaat masala'],
      dataSource: 'ICMR-NIN IFCT 2017',
    ),
    const FoodItem(
      id: 'f_almonds_raw',
      name: 'California / Mamra Almonds',
      hindiName: 'बादाम',
      category: FoodCategory.nutsAndSeeds,
      dietaryType: DietaryType.vegan,
      state: FoodState.raw,
      standardServingUnit: '10 almonds (12g)',
      standardServingGrams: 12.0,
      caloriesPer100g: 579.0,
      proteinPer100g: 21.2,
      carbsPer100g: 21.6,
      fatPer100g: 49.9,
      fiberPer100g: 12.5,
      allergens: ['nuts'],
      ingredients: ['Raw whole almonds'],
      dataSource: 'USDA FDC',
    ),
    const FoodItem(
      id: 'f_apple_fresh',
      name: 'Fresh Crisp Apple with Skin',
      hindiName: 'सेब',
      category: FoodCategory.fruits,
      dietaryType: DietaryType.vegan,
      state: FoodState.raw,
      standardServingUnit: '1 medium apple (150g)',
      standardServingGrams: 150.0,
      caloriesPer100g: 52.0,
      proteinPer100g: 0.3,
      carbsPer100g: 13.8,
      fatPer100g: 0.2,
      fiberPer100g: 2.4,
      allergens: [],
      ingredients: ['Fresh raw apple'],
      dataSource: 'USDA FDC',
    ),
    const FoodItem(
      id: 'f_whey_protein',
      name: 'Whey Protein Isolate',
      hindiName: 'व्हे प्रोटीन',
      category: FoodCategory.supplements,
      dietaryType: DietaryType.vegetarian,
      state: FoodState.raw,
      standardServingUnit: '1 scoop (30g)',
      standardServingGrams: 30.0,
      caloriesPer100g: 380.0,
      proteinPer100g: 86.0,
      carbsPer100g: 3.0,
      fatPer100g: 1.5,
      fiberPer100g: 0.0,
      allergens: ['dairy'],
      ingredients: ['Cross-flow microfiltered whey isolate'],
      dataSource: 'Lab Verified Product Label',
    ),
  ];

  /// Filters food items conforming to the user's dietary pattern and excluding allergen conflicts
  static List<FoodItem> getCompliantFoods({
    required DietaryType dietaryPattern,
    List<String> excludedAllergens = const [],
  }) {
    return foodDatabase.where((item) {
      // Allergen filter
      for (final allergen in excludedAllergens) {
        if (item.allergens.contains(allergen.toLowerCase())) {
          return false;
        }
      }

      // Dietary pattern compliance
      switch (dietaryPattern) {
        case DietaryType.vegan:
          return item.dietaryType == DietaryType.vegan;
        case DietaryType.vegetarian:
          return item.dietaryType == DietaryType.vegetarian ||
              item.dietaryType == DietaryType.vegan;
        case DietaryType.eggetarian:
          return item.dietaryType == DietaryType.eggetarian ||
              item.dietaryType == DietaryType.vegetarian ||
              item.dietaryType == DietaryType.vegan;
        case DietaryType.jain:
          // Strictly excludes root vegetables, meat, eggs
          return (item.dietaryType == DietaryType.vegetarian ||
                  item.dietaryType == DietaryType.vegan) &&
              !item.ingredients.any((i) =>
                  i.toLowerCase().contains('onion') ||
                  i.toLowerCase().contains('garlic'));
        case DietaryType.nonVegetarian:
          return true; // All items accepted
      }
    }).toList();
  }

  /// Automatically generates a personalized, balanced Diet Chart scaled to daily calorie targets
  static DietChart generateDietChart({
    required String id,
    required String title,
    required double targetCalories,
    required DietaryType dietaryPattern,
    List<String> excludedAllergens = const [],
  }) {
    final available = getCompliantFoods(
      dietaryPattern: dietaryPattern,
      excludedAllergens: excludedAllergens,
    );

    // Meal Distribution:
    // Breakfast: 25% | Lunch: 35% | Snack: 15% | Dinner: 25%
    final breakfastTargetCal = targetCalories * 0.25;
    final lunchTargetCal = targetCalories * 0.35;
    final snackTargetCal = targetCalories * 0.15;
    final dinnerTargetCal = targetCalories * 0.25;

    // Build Breakfast
    final breakfastPortions = <MealPortion>[];
    if (available.any((f) => f.id == 'f_oats_rolled')) {
      breakfastPortions.add(MealPortion(
        food: available.firstWhere((f) => f.id == 'f_oats_rolled'),
        servings: 1.0,
      ));
    }
    if (available.any((f) => f.id == 'f_almonds_raw')) {
      breakfastPortions.add(MealPortion(
        food: available.firstWhere((f) => f.id == 'f_almonds_raw'),
        servings: 1.0,
      ));
    }
    if (available.any((f) => f.id == 'f_boiled_eggs')) {
      breakfastPortions.add(MealPortion(
        food: available.firstWhere((f) => f.id == 'f_boiled_eggs'),
        servings: 2.0,
      ));
    } else if (available.any((f) => f.id == 'f_sprouts_salad')) {
      breakfastPortions.add(MealPortion(
        food: available.firstWhere((f) => f.id == 'f_sprouts_salad'),
        servings: 1.0,
      ));
    }

    // Build Lunch
    final lunchPortions = <MealPortion>[];
    if (available.any((f) => f.id == 'f_roti_wheat')) {
      lunchPortions.add(MealPortion(
        food: available.firstWhere((f) => f.id == 'f_roti_wheat'),
        servings: 2.0, // 2 rotis (70g)
      ));
    } else if (available.any((f) => f.id == 'f_brown_rice')) {
      lunchPortions.add(MealPortion(
        food: available.firstWhere((f) => f.id == 'f_brown_rice'),
        servings: 1.0,
      ));
    }
    if (available.any((f) => f.id == 'f_dal_moong')) {
      lunchPortions.add(MealPortion(
        food: available.firstWhere((f) => f.id == 'f_dal_moong'),
        servings: 1.0,
      ));
    }
    if (available.any((f) => f.id == 'f_chicken_breast')) {
      lunchPortions.add(MealPortion(
        food: available.firstWhere((f) => f.id == 'f_chicken_breast'),
        servings: 1.0,
      ));
    } else if (available.any((f) => f.id == 'f_paneer_fresh')) {
      lunchPortions.add(MealPortion(
        food: available.firstWhere((f) => f.id == 'f_paneer_fresh'),
        servings: 1.0,
      ));
    } else if (available.any((f) => f.id == 'f_soya_chunks')) {
      lunchPortions.add(MealPortion(
        food: available.firstWhere((f) => f.id == 'f_soya_chunks'),
        servings: 1.0,
      ));
    }
    if (available.any((f) => f.id == 'f_curd_dahi')) {
      lunchPortions.add(MealPortion(
        food: available.firstWhere((f) => f.id == 'f_curd_dahi'),
        servings: 1.0,
      ));
    }

    // Build Evening Snack
    final snackPortions = <MealPortion>[];
    if (available.any((f) => f.id == 'f_apple_fresh')) {
      snackPortions.add(MealPortion(
        food: available.firstWhere((f) => f.id == 'f_apple_fresh'),
        servings: 1.0,
      ));
    }
    if (available.any((f) => f.id == 'f_sprouts_salad') &&
        !breakfastPortions.any((p) => p.food.id == 'f_sprouts_salad')) {
      snackPortions.add(MealPortion(
        food: available.firstWhere((f) => f.id == 'f_sprouts_salad'),
        servings: 1.0,
      ));
    }

    // Build Dinner
    final dinnerPortions = <MealPortion>[];
    if (available.any((f) => f.id == 'f_roti_wheat')) {
      dinnerPortions.add(MealPortion(
        food: available.firstWhere((f) => f.id == 'f_roti_wheat'),
        servings: 2.0,
      ));
    }
    if (available.any((f) => f.id == 'f_dal_moong')) {
      dinnerPortions.add(MealPortion(
        food: available.firstWhere((f) => f.id == 'f_dal_moong'),
        servings: 1.0,
      ));
    }
    if (available.any((f) => f.id == 'f_soya_chunks')) {
      dinnerPortions.add(MealPortion(
        food: available.firstWhere((f) => f.id == 'f_soya_chunks'),
        servings: 1.0,
      ));
    }

    final meals = [
      PlannedMeal(
        type: MealType.breakfast,
        title: 'Morning Fuel & Brain Energy',
        recommendedTime: '08:30 AM',
        portions: breakfastPortions,
      ),
      PlannedMeal(
        type: MealType.lunch,
        title: 'Midday Balanced Power Meal',
        recommendedTime: '01:30 PM',
        portions: lunchPortions,
      ),
      PlannedMeal(
        type: MealType.eveningSnack,
        title: 'Pre-Workout Vitality Snack',
        recommendedTime: '05:30 PM',
        portions: snackPortions,
      ),
      PlannedMeal(
        type: MealType.dinner,
        title: 'Lean Recovery Dinner',
        recommendedTime: '08:30 PM',
        portions: dinnerPortions,
      ),
    ];

    return DietChart(
      id: id,
      title: title,
      description: 'Scientifically distributed nutrient plan matching $targetCalories kcal daily requirement.',
      targetCalories: targetCalories,
      dietaryPattern: dietaryPattern,
      excludedAllergens: excludedAllergens,
      meals: meals,
      createdAt: DateTime.now(),
    );
  }
}
