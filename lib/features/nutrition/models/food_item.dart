enum DietaryType {
  vegetarian,
  vegan,
  eggetarian,
  nonVegetarian,
  jain,
}

enum FoodState {
  raw,
  cooked,
}

enum FoodCategory {
  grainsAndCereals,
  pulsesAndLegumes,
  dairyAndAlternatives,
  vegetables,
  fruits,
  meatPoultryFish,
  nutsAndSeeds,
  fatsAndOils,
  supplements,
}

/// Normalized Food Item data model with nutrient quantities per 100g and default serving
class FoodItem {
  final String id;
  final String name;
  final String hindiName;
  final FoodCategory category;
  final DietaryType dietaryType;
  final FoodState state;
  final String standardServingUnit; // e.g. "1 bowl (150g)", "1 roti (35g)", "1 scoop (30g)"
  final double standardServingGrams;
  
  // Nutrients per 100 grams
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final double fiberPer100g;

  final List<String> allergens; // e.g. ["dairy", "gluten", "nuts"]
  final List<String> ingredients;
  final String dataSource; // "IFCT (ICMR-NIN)" or "USDA FDC"
  final String? preparationNotes;

  const FoodItem({
    required this.id,
    required this.name,
    this.hindiName = '',
    required this.category,
    required this.dietaryType,
    this.state = FoodState.cooked,
    required this.standardServingUnit,
    required this.standardServingGrams,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    this.fiberPer100g = 0.0,
    this.allergens = const [],
    this.ingredients = const [],
    this.dataSource = 'ICMR-NIN IFCT 2017 & USDA FDC',
    this.preparationNotes,
  });

  /// Calculates scaled nutrients for a given weight in grams
  NutrientValues calculateForGrams(double grams) {
    final factor = grams / 100.0;
    return NutrientValues(
      calories: double.parse((caloriesPer100g * factor).toStringAsFixed(1)),
      protein: double.parse((proteinPer100g * factor).toStringAsFixed(1)),
      carbs: double.parse((carbsPer100g * factor).toStringAsFixed(1)),
      fat: double.parse((fatPer100g * factor).toStringAsFixed(1)),
      fiber: double.parse((fiberPer100g * factor).toStringAsFixed(1)),
    );
  }

  /// Calculates scaled nutrients for a given number of standard servings
  NutrientValues calculateForServings(double servings) {
    final grams = standardServingGrams * servings;
    return calculateForGrams(grams);
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'hindiName': hindiName,
        'category': category.name,
        'dietaryType': dietaryType.name,
        'state': state.name,
        'standardServingUnit': standardServingUnit,
        'standardServingGrams': standardServingGrams,
        'caloriesPer100g': caloriesPer100g,
        'proteinPer100g': proteinPer100g,
        'carbsPer100g': carbsPer100g,
        'fatPer100g': fatPer100g,
        'fiberPer100g': fiberPer100g,
        'allergens': allergens,
        'ingredients': ingredients,
        'dataSource': dataSource,
        'preparationNotes': preparationNotes,
      };

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'] as String,
      name: map['name'] as String,
      hindiName: (map['hindiName'] as String?) ?? '',
      category: FoodCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => FoodCategory.grainsAndCereals,
      ),
      dietaryType: DietaryType.values.firstWhere(
        (e) => e.name == map['dietaryType'],
        orElse: () => DietaryType.vegetarian,
      ),
      state: FoodState.values.firstWhere(
        (e) => e.name == map['state'],
        orElse: () => FoodState.cooked,
      ),
      standardServingUnit: map['standardServingUnit'] as String,
      standardServingGrams: (map['standardServingGrams'] as num).toDouble(),
      caloriesPer100g: (map['caloriesPer100g'] as num).toDouble(),
      proteinPer100g: (map['proteinPer100g'] as num).toDouble(),
      carbsPer100g: (map['carbsPer100g'] as num).toDouble(),
      fatPer100g: (map['fatPer100g'] as num).toDouble(),
      fiberPer100g: ((map['fiberPer100g'] ?? 0.0) as num).toDouble(),
      allergens: List<String>.from(map['allergens'] ?? []),
      ingredients: List<String>.from(map['ingredients'] ?? []),
      dataSource: (map['dataSource'] as String?) ?? 'ICMR-NIN IFCT 2017 & USDA FDC',
      preparationNotes: map['preparationNotes'] as String?,
    );
  }
}

class NutrientValues {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;

  const NutrientValues({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
  });

  NutrientValues operator +(NutrientValues other) {
    return NutrientValues(
      calories: double.parse((calories + other.calories).toStringAsFixed(1)),
      protein: double.parse((protein + other.protein).toStringAsFixed(1)),
      carbs: double.parse((carbs + other.carbs).toStringAsFixed(1)),
      fat: double.parse((fat + other.fat).toStringAsFixed(1)),
      fiber: double.parse((fiber + other.fiber).toStringAsFixed(1)),
    );
  }

  Map<String, dynamic> toMap() => {
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'fiber': fiber,
      };
}
