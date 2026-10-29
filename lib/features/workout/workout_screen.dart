import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import 'workout_models.dart';
import 'workout_service.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final List<WorkoutRoutine> _routines = WorkoutService.getRoutines();
  DifficultyLevel _selectedLevel = DifficultyLevel.beginner;

  // Active workout timer state
  bool _isWorkoutActive = false;
  int _timerSeconds = 0;
  Timer? _workoutTimer;
  String _activeRoutineTitle = '';

  void _startWorkout(WorkoutRoutine routine) {
    setState(() {
      _isWorkoutActive = true;
      _activeRoutineTitle = routine.title;
      _timerSeconds = 0;
    });
    _workoutTimer?.cancel();
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _timerSeconds++);
    });
  }

  void _finishWorkout() {
    _workoutTimer?.cancel();
    final duration = _timerSeconds;
    setState(() {
      _isWorkoutActive = false;
      _timerSeconds = 0;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.successTeal, size: 28),
            const SizedBox(width: 8),
            Text('Workout Completed!', style: AppTypography.headingMedium()),
          ],
        ),
        content: Text(
          'Great job finishing "$_activeRoutineTitle"!\nTotal Active Time: ${duration ~/ 60}m ${duration % 60}s.\nCalories Burned: ~${(duration * 0.12).toInt()} kcal.',
          style: AppTypography.bodyMedium(),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save & Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _workoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredRoutines = _routines.where((r) => r.level == _selectedLevel).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts & Training', style: AppTypography.headingLarge(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Workout Bar (if running)
            if (_isWorkoutActive) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.burgundyGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBurgundy.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('WORKOUT IN PROGRESS', style: AppTypography.bodySmall(color: AppColors.roseChampagne)),
                        Text(_activeRoutineTitle, style: AppTypography.headingSmall(color: Colors.white)),
                        Text(
                          '${(_timerSeconds ~/ 60).toString().padLeft(2, '0')}:${(_timerSeconds % 60).toString().padLeft(2, '0')}',
                          style: AppTypography.metricValue(color: Colors.white),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.successTeal,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(100, 44),
                      ),
                      onPressed: _finishWorkout,
                      child: const Text('Finish'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Difficulty Level Filters
            Text('Select Experience Level', style: AppTypography.headingSmall()),
            const SizedBox(height: 8),
            Row(
              children: DifficultyLevel.values.map((lvl) {
                final isSelected = _selectedLevel == lvl;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(lvl.name.toUpperCase()),
                    selected: isSelected,
                    selectedColor: AppColors.primaryBurgundy,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.charcoal,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedLevel = lvl);
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Routines
            Text('Available Training Programs', style: AppTypography.headingLarge()),
            const SizedBox(height: 12),

            ...filteredRoutines.map((routine) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(routine.title, style: AppTypography.headingMedium()),
                                const SizedBox(height: 4),
                                Text(routine.subtitle, style: AppTypography.bodySmall()),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.lightPink,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 14, color: AppColors.deepBurgundy),
                                const SizedBox(width: 4),
                                Text(
                                  '${routine.estimatedDurationMinutes}m',
                                  style: AppTypography.bodySmall(color: AppColors.deepBurgundy).copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // Exercises in Routine
                      Text('Target Exercises (${routine.exercises.length})', style: AppTypography.headingSmall()),
                      const SizedBox(height: 8),
                      ...routine.exercises.map((item) {
                        final ex = item.exercise;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryBurgundy,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  ex.name,
                                  style: AppTypography.bodyLarge().copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                item.targetDurationSeconds > 0
                                    ? '${item.sets} sets × ${item.targetDurationSeconds}s'
                                    : '${item.sets} sets × ${item.targetReps} reps',
                                style: AppTypography.bodySmall(color: AppColors.slateGrey),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 16),

                      ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start Routine'),
                        onPressed: () => _startWorkout(routine),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
