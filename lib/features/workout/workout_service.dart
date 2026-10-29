import 'workout_models.dart';

/// MANI FIT Curated Exercise Database and Workout Generation Service
class WorkoutService {
  WorkoutService._();

  static final List<Exercise> exerciseLibrary = [
    const Exercise(
      id: 'ex_bodyweight_squat',
      name: 'Bodyweight Squats',
      targetMuscle: MuscleGroup.legs,
      equipment: ['bodyweight'],
      difficulty: DifficultyLevel.beginner,
      instructions: 'Stand feet shoulder-width apart. Hinge at hips and bend knees until thighs are parallel to ground. Drive through heels to return.',
      safetyNotes: 'Keep knees tracking in line with toes. Do not let knees cave inward. Maintain neutral spine.',
    ),
    const Exercise(
      id: 'ex_pushups',
      name: 'Classic Push-Ups',
      targetMuscle: MuscleGroup.chest,
      equipment: ['bodyweight'],
      difficulty: DifficultyLevel.beginner,
      instructions: 'Hands slightly wider than shoulders, core braced in plank. Lower chest to floor and press up explosively.',
      safetyNotes: 'Avoid sagging lower back or flaring elbows out at 90 degrees. Keep elbows at 45 degree angle.',
    ),
    const Exercise(
      id: 'ex_plank',
      name: 'Forearm Core Plank',
      targetMuscle: MuscleGroup.core,
      equipment: ['bodyweight'],
      difficulty: DifficultyLevel.beginner,
      instructions: 'Rest on forearms and toes. Engage glutes, quads, and abdominal wall to hold rigid straight line.',
      safetyNotes: 'Breathe continuously. Stop immediately if lower back pinches.',
    ),
    const Exercise(
      id: 'ex_db_goblet_squat',
      name: 'Dumbbell Goblet Squat',
      targetMuscle: MuscleGroup.legs,
      equipment: ['dumbbells'],
      difficulty: DifficultyLevel.intermediate,
      instructions: 'Hold one dumbbell vertically at chest level. Descend deep between knees keeping chest upright.',
      safetyNotes: 'Maintain upright torso throughout the entire descent.',
    ),
    const Exercise(
      id: 'ex_db_overhead_press',
      name: 'Standing Dumbbell Overhead Press',
      targetMuscle: MuscleGroup.shoulders,
      equipment: ['dumbbells'],
      difficulty: DifficultyLevel.intermediate,
      instructions: 'Hold dumbbells at shoulder height. Press upward until arms lock overhead without arching lumbar spine.',
      safetyNotes: 'Squeeze glutes and abs to avoid lumbar hyperextension.',
    ),
    const Exercise(
      id: 'ex_db_bent_over_row',
      name: 'Dual Dumbbell Bent-Over Row',
      targetMuscle: MuscleGroup.back,
      equipment: ['dumbbells'],
      difficulty: DifficultyLevel.intermediate,
      instructions: 'Hinge forward 45 degrees with flat back. Pull elbows back toward hips, squeezing shoulder blades together.',
      safetyNotes: 'Keep cervical spine neutral. Do not round upper thoracic or lumbar spine.',
    ),
    const Exercise(
      id: 'ex_barbell_deadlift',
      name: 'Conventional Barbell Deadlift',
      targetMuscle: MuscleGroup.back,
      equipment: ['barbell'],
      difficulty: DifficultyLevel.advanced,
      instructions: 'Feet under bar hip-width apart. Grip bar outside knees, set lats tight, wedge hips down, and stand tall by extending hips.',
      safetyNotes: 'Do not jerk the weight off the floor. Pull slack out of the bar first. Discontinue if spinal flexion occurs.',
    ),
  ];

  static List<WorkoutRoutine> getRoutines() {
    return [
      WorkoutRoutine(
        id: 'routine_home_foundation',
        title: 'Home Bodyweight Foundation',
        subtitle: 'Build functional strength, joint stability, and core resilience with zero equipment.',
        level: DifficultyLevel.beginner,
        location: WorkoutLocation.home,
        estimatedDurationMinutes: 25,
        exercises: [
          ExercisePlanItem(
            exercise: exerciseLibrary.firstWhere((e) => e.id == 'ex_bodyweight_squat'),
            sets: 3,
            targetReps: 15,
            restSeconds: 60,
          ),
          ExercisePlanItem(
            exercise: exerciseLibrary.firstWhere((e) => e.id == 'ex_pushups'),
            sets: 3,
            targetReps: 10,
            restSeconds: 60,
          ),
          ExercisePlanItem(
            exercise: exerciseLibrary.firstWhere((e) => e.id == 'ex_plank'),
            sets: 3,
            targetDurationSeconds: 45,
            restSeconds: 45,
          ),
        ],
      ),
      WorkoutRoutine(
        id: 'routine_dumbbell_hypertrophy',
        title: 'Full Body Dumbbell Sculpt',
        subtitle: 'Progressive overload training for muscle tone, metabolic boost, and posture.',
        level: DifficultyLevel.intermediate,
        location: WorkoutLocation.hybrid,
        estimatedDurationMinutes: 40,
        exercises: [
          ExercisePlanItem(
            exercise: exerciseLibrary.firstWhere((e) => e.id == 'ex_db_goblet_squat'),
            sets: 4,
            targetReps: 12,
            restSeconds: 75,
          ),
          ExercisePlanItem(
            exercise: exerciseLibrary.firstWhere((e) => e.id == 'ex_db_bent_over_row'),
            sets: 4,
            targetReps: 12,
            restSeconds: 75,
          ),
          ExercisePlanItem(
            exercise: exerciseLibrary.firstWhere((e) => e.id == 'ex_db_overhead_press'),
            sets: 3,
            targetReps: 10,
            restSeconds: 60,
          ),
          ExercisePlanItem(
            exercise: exerciseLibrary.firstWhere((e) => e.id == 'ex_plank'),
            sets: 3,
            targetDurationSeconds: 60,
            restSeconds: 45,
          ),
        ],
      ),
    ];
  }
}
