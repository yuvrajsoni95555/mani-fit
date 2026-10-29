enum DifficultyLevel {
  beginner,
  intermediate,
  advanced,
}

enum WorkoutLocation {
  home,
  gym,
  hybrid,
}

enum MuscleGroup {
  chest,
  back,
  legs,
  shoulders,
  arms,
  core,
  fullBody,
  cardio,
}

class Exercise {
  final String id;
  final String name;
  final MuscleGroup targetMuscle;
  final List<String> equipment; // e.g. ["bodyweight"], ["dumbbells"], ["barbell"]
  final DifficultyLevel difficulty;
  final String instructions;
  final String safetyNotes;
  final String? videoOrAnimationUrl;

  const Exercise({
    required this.id,
    required this.name,
    required this.targetMuscle,
    required this.equipment,
    required this.difficulty,
    required this.instructions,
    required this.safetyNotes,
    this.videoOrAnimationUrl,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'targetMuscle': targetMuscle.name,
        'equipment': equipment,
        'difficulty': difficulty.name,
        'instructions': instructions,
        'safetyNotes': safetyNotes,
        'videoOrAnimationUrl': videoOrAnimationUrl,
      };
}

class ExercisePlanItem {
  final Exercise exercise;
  final int sets;
  final int targetReps;
  final int targetDurationSeconds; // for planks / cardio
  final int restSeconds;

  const ExercisePlanItem({
    required this.exercise,
    required this.sets,
    this.targetReps = 12,
    this.targetDurationSeconds = 0,
    this.restSeconds = 60,
  });

  Map<String, dynamic> toMap() => {
        'exercise': exercise.toMap(),
        'sets': sets,
        'targetReps': targetReps,
        'targetDurationSeconds': targetDurationSeconds,
        'restSeconds': restSeconds,
      };
}

class WorkoutRoutine {
  final String id;
  final String title;
  final String subtitle;
  final DifficultyLevel level;
  final WorkoutLocation location;
  final int estimatedDurationMinutes;
  final List<ExercisePlanItem> exercises;

  const WorkoutRoutine({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.level,
    required this.location,
    required this.estimatedDurationMinutes,
    required this.exercises,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'level': level.name,
        'location': location.name,
        'estimatedDurationMinutes': estimatedDurationMinutes,
        'exercises': exercises.map((e) => e.toMap()).toList(),
      };
}

class CompletedWorkoutLog {
  final String id;
  final String routineId;
  final String routineTitle;
  final DateTime completedAt;
  final int durationMinutes;
  final int totalSetsCompleted;
  final double estimatedCaloriesBurned;
  final String? userNotes;

  const CompletedWorkoutLog({
    required this.id,
    required this.routineId,
    required this.routineTitle,
    required this.completedAt,
    required this.durationMinutes,
    required this.totalSetsCompleted,
    required this.estimatedCaloriesBurned,
    this.userNotes,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'routineId': routineId,
        'routineTitle': routineTitle,
        'completedAt': completedAt.toIso8601String(),
        'durationMinutes': durationMinutes,
        'totalSetsCompleted': totalSetsCompleted,
        'estimatedCaloriesBurned': estimatedCaloriesBurned,
        'userNotes': userNotes,
      };
}
