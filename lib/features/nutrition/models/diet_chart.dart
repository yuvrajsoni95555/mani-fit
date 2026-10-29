import 'food_item.dart';

enum MealType {
  breakfast,
  morningSnack,
  lunch,
  eveningSnack,
  dinner,
}

class MealPortion {
  final FoodItem food;
  final double servings; // e.g., 2.0 rotis, 1.5 bowls
  final double totalGrams;
  final NutrientValues nutrients;

  MealPortion({
    required this.food,
    required this.servings,
    double? customGrams,
  })  : totalGrams = customGrams ?? (food.standardServingGrams * servings),
        nutrients = food.calculateForGrams(customGrams ?? (food.standardServingGrams * servings));

  MealPortion copyWith({
    FoodItem? food,
    double? servings,
    double? customGrams,
  }) {
    return MealPortion(
      food: food ?? this.food,
      servings: servings ?? this.servings,
      customGrams: customGrams,
    );
  }

  Map<String, dynamic> toMap() => {
        'food': food.toMap(),
        'servings': servings,
        'totalGrams': totalGrams,
        'nutrients': nutrients.toMap(),
      };
}

class PlannedMeal {
  final MealType type;
  final String title;
  final String recommendedTime;
  final List<MealPortion> portions;

  const PlannedMeal({
    required this.type,
    required this.title,
    required this.recommendedTime,
    required this.portions,
  });

  NutrientValues get totalNutrients {
    double cal = 0, p = 0, c = 0, f = 0, fib = 0;
    for (final pItem in portions) {
      cal += pItem.nutrients.calories;
      p += pItem.nutrients.protein;
      c += pItem.nutrients.carbs;
      f += pItem.nutrients.fat;
      fib += pItem.nutrients.fiber;
    }
    return NutrientValues(
      calories: double.parse(cal.toStringAsFixed(1)),
      protein: double.parse(p.toStringAsFixed(1)),
      carbs: double.parse(c.toStringAsFixed(1)),
      fat: double.parse(f.toStringAsFixed(1)),
      fiber: double.parse(fib.toStringAsFixed(1)),
    );
  }

  PlannedMeal copyWithPortions(List<MealPortion> newPortions) {
    return PlannedMeal(
      type: type,
      title: title,
      recommendedTime: recommendedTime,
      portions: newPortions,
    );
  }

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'title': title,
        'recommendedTime': recommendedTime,
        'portions': portions.map((p) => p.toMap()).toList(),
        'totalNutrients': totalNutrients.toMap(),
      };
}

class DietChart {
  final String id;
  final String title;
  final String description;
  final double targetCalories;
  final DietaryType dietaryPattern;
  final List<String> excludedAllergens;
  final List<PlannedMeal> meals;
  final DateTime createdAt;
  final bool isCustomized;

  const DietChart({
    required this.id,
    required this.title,
    required this.description,
    required this.targetCalories,
    required this.dietaryPattern,
    this.excludedAllergens = const [],
    required this.meals,
    required this.createdAt,
    this.isCustomized = false,
  });

  NutrientValues get dailyTotalNutrients {
    double cal = 0, p = 0, c = 0, f = 0, fib = 0;
    for (final meal in meals) {
      final n = meal.totalNutrients;
      cal += n.calories;
      p += n.protein;
      c += n.carbs;
      f += n.fat;
      fib += n.fiber;
    }
    return NutrientValues(
      calories: double.parse(cal.toStringAsFixed(1)),
      protein: double.parse(p.toStringAsFixed(1)),
      carbs: double.parse(c.toStringAsFixed(1)),
      fat: double.parse(f.toStringAsFixed(1)),
      fiber: double.parse(fib.toStringAsFixed(1)),
    );
  }

  /// Aggregates all ingredients into an organized grocery shopping list
  Map<String, String> generateGroceryList() {
    final Map<String, double> aggregatedGrams = {};
    for (final meal in meals) {
      for (final portion in meal.portions) {
        final key = portion.food.name;
        aggregatedGrams[key] = (aggregatedGrams[key] ?? 0.0) + portion.totalGrams;
      }
    }

    final Map<String, String> groceryList = {};
    aggregatedGrams.forEach((foodName, grams) {
      if (grams >= 1000) {
        groceryList[foodName] = '${(grams / 1000).toStringAsFixed(1)} kg';
      } else {
        groceryList[foodName] = '${grams.toStringAsFixed(0)} g';
      }
    });
    return groceryList;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'targetCalories': targetCalories,
        'dietaryPattern': dietaryPattern.name,
        'excludedAllergens': excludedAllergens,
        'meals': meals.map((m) => m.toMap()).toList(),
        'dailyTotalNutrients': dailyTotalNutrients.toMap(),
        'createdAt': createdAt.toIso8601String(),
        'isCustomized': isCustomized,
      };
}
