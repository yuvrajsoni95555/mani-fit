import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

class AiChatMessage {
  final String sender; // 'user' | 'coach'
  final String message;
  final DateTime timestamp;
  final bool isDisclaimerVisible;

  const AiChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
    this.isDisclaimerVisible = false,
  });

  Map<String, dynamic> toMap() => {
        'sender': sender,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'isDisclaimerVisible': isDisclaimerVisible,
      };
}

/// MANI FIT Context-Aware AI Fitness Coach Service
class AiCoachService {
  final String? apiKey;
  final String modelEndpoint;

  AiCoachService({
    this.apiKey,
    this.modelEndpoint = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent',
  });

  /// Constructs the system prompt embedding user context and strict wellness guardrails
  String _buildSystemPrompt({
    required String userName,
    required int age,
    required String goal,
    required double dailyCalories,
    required String dietaryPattern,
  }) {
    return '''
You are the MANI FIT AI Fitness Coach, an empathetic, motivating, and evidence-based personal health advisor for the MANI FIT application ("Your Health. Your Goals. Your Better You.").

USER CONTEXT:
- Name: $userName
- Age: $age
- Fitness Goal: $goal
- Daily Caloric Target: ${dailyCalories.toStringAsFixed(0)} kcal
- Dietary Pattern: $dietaryPattern

STRICT SAFETY AND CLINICAL BOUNDARIES:
1. You are NOT a medical doctor or clinical dietitian.
2. NEVER diagnose medical conditions, symptoms, injuries, or eating disorders.
3. NEVER prescribe medications, pharmaceuticals, or therapeutic dosages.
4. NEVER advise severe caloric restriction below ${AppConstants.minSafeCaloriesFemale} kcal/day for women or ${AppConstants.minSafeCaloriesMale} kcal/day for men.
5. If the user reports chest pain, extreme dizziness, shortness of breath, or sharp joint pain, immediately advise seeking emergency medical attention.
6. Provide supportive, actionable nutrition, habit formation, exercise technique tips, and workout recovery advice.
''';
  }

  /// Sends user query to Gemini API or executes evidence-based fallback
  Future<String> queryCoach({
    required String userQuery,
    required String userName,
    required int age,
    required String goal,
    required double dailyCalories,
    required String dietaryPattern,
  }) async {
    // Check if real API key is configured
    if (apiKey != null && apiKey!.isNotEmpty && !apiKey!.startsWith('YOUR_')) {
      try {
        final systemPrompt = _buildSystemPrompt(
          userName: userName,
          age: age,
          goal: goal,
          dailyCalories: dailyCalories,
          dietaryPattern: dietaryPattern,
        );

        final url = Uri.parse('$modelEndpoint?key=$apiKey');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'role': 'user',
                'parts': [
                  {'text': '$systemPrompt\n\nUser Question: $userQuery'}
                ]
              }
            ],
            'generationConfig': {
              'temperature': 0.7,
              'maxOutputTokens': 800,
            }
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final candidates = data['candidates'] as List?;
          if (candidates != null && candidates.isNotEmpty) {
            final text = candidates[0]['content']['parts'][0]['text'] as String;
            return text;
          }
        }
      } catch (_) {
        // Fall back gracefully to local heuristic advisor
      }
    }

    // Graceful offline & zero-budget evidence-based heuristic advisor
    return _generateHeuristicFallback(
      userQuery: userQuery,
      goal: goal,
      dailyCalories: dailyCalories,
      dietaryPattern: dietaryPattern,
    );
  }

  /// Evidence-based local fallback responses when network/API key is unavailable
  String _generateHeuristicFallback({
    required String userQuery,
    required String goal,
    required double dailyCalories,
    required String dietaryPattern,
  }) {
    final q = userQuery.toLowerCase();

    if (q.contains('protein') || q.contains('muscle')) {
      return 'For your $goal goal, aim for approximately 1.6 to 2.2 grams of protein per kilogram of body weight. '
          'Great $dietaryPattern options in your meal plan include lentils, paneer, eggs, chicken breast, and soya chunks! '
          'Distributing your protein across 3 to 4 meals maximizes muscle protein synthesis.';
    }

    if (q.contains('calorie') || q.contains('deficit') || q.contains('cut')) {
      return 'Your current daily target is ${dailyCalories.toStringAsFixed(0)} kcal. '
          'A sustainable deficit of 300–500 kcal per day allows steady fat loss (~0.5 kg/week) while preserving lean muscle mass and metabolic rate. '
          'Avoid crash diets, as they can cause muscle catabolism and hormonal fatigue.';
    }

    if (q.contains('water') || q.contains('hydration')) {
      return 'Hydration is crucial for energy and muscle recovery! A baseline of 2.5 to 3.5 liters daily is recommended, '
          'adding 500ml for every hour of moderate-to-vigorous exercise.';
    }

    if (q.contains('sleep') || q.contains('recovery') || q.contains('rest')) {
      return 'Growth hormone and muscle tissue repair occur predominantly during deep non-REM sleep. '
          'Aim for 7 to 9 hours of quality sleep with a cool room and consistent sleep schedule.';
    }

    return 'Welcome to MANI FIT Coaching! To support your $goal journey, focus on: '
        '1) Consistency with your ${dailyCalories.toStringAsFixed(0)} kcal meal plan, '
        '2) Progressive overload in your workouts, '
        '3) Quality recovery. What specific area would you like help optimizing today?';
  }
}
