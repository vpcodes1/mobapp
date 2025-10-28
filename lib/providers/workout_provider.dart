import 'package:flutter/foundation.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import '../models/workout_exercise.dart';
import '../models/workout_set.dart';
import '../services/database_service.dart';

class WorkoutProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService.instance;

  List<Workout> _workouts = [];
  List<Exercise> _exercises = [];
  Workout? _currentWorkout;
  Map<int, List<WorkoutExercise>> _workoutExercises = {};
  Map<int, List<WorkoutSet>> _exerciseSets = {};
  bool _isLoading = false;

  List<Workout> get workouts => _workouts;
  List<Exercise> get exercises => _exercises;
  Workout? get currentWorkout => _currentWorkout;
  bool get isLoading => _isLoading;

  Future<void> loadExercises() async {
    _isLoading = true;
    notifyListeners();

    try {
      _exercises = await _dbService.getAllExercises();
    } catch (e) {
      debugPrint('Error loading exercises: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadWorkouts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _workouts = await _dbService.getAllWorkouts();
    } catch (e) {
      debugPrint('Error loading workouts: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadRecentWorkouts({int limit = 10}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _workouts = await _dbService.getRecentWorkouts(limit: limit);
    } catch (e) {
      debugPrint('Error loading recent workouts: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Workout?> startWorkout(String name) async {
    try {
      final workout = Workout(
        name: name,
        startTime: DateTime.now(),
        completed: false,
      );
      _currentWorkout = await _dbService.createWorkout(workout);
      notifyListeners();
      return _currentWorkout;
    } catch (e) {
      debugPrint('Error starting workout: $e');
      return null;
    }
  }

  Future<void> endWorkout() async {
    if (_currentWorkout == null) return;

    try {
      final updatedWorkout = _currentWorkout!.copyWith(
        endTime: DateTime.now(),
        completed: true,
      );
      await _dbService.updateWorkout(updatedWorkout);
      _currentWorkout = null;
      await loadRecentWorkouts();
      notifyListeners();
    } catch (e) {
      debugPrint('Error ending workout: $e');
    }
  }

  Future<void> cancelWorkout() async {
    if (_currentWorkout == null) return;

    try {
      await _dbService.deleteWorkout(_currentWorkout!.id!);
      _currentWorkout = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error canceling workout: $e');
    }
  }

  Future<WorkoutExercise?> addExerciseToWorkout(int workoutId, int exerciseId) async {
    try {
      final exercises = _workoutExercises[workoutId] ?? [];
      final orderIndex = exercises.length;

      final workoutExercise = WorkoutExercise(
        workoutId: workoutId,
        exerciseId: exerciseId,
        orderIndex: orderIndex,
      );

      final created = await _dbService.createWorkoutExercise(workoutExercise);

      if (_workoutExercises[workoutId] == null) {
        _workoutExercises[workoutId] = [];
      }
      _workoutExercises[workoutId]!.add(created);

      notifyListeners();
      return created;
    } catch (e) {
      debugPrint('Error adding exercise to workout: $e');
      return null;
    }
  }

  Future<WorkoutSet?> addSet(int workoutExerciseId, int reps, double weight) async {
    try {
      final sets = _exerciseSets[workoutExerciseId] ?? [];
      final setNumber = sets.length + 1;

      final workoutSet = WorkoutSet(
        workoutExerciseId: workoutExerciseId,
        setNumber: setNumber,
        reps: reps,
        weight: weight,
        completed: true,
      );

      final created = await _dbService.createWorkoutSet(workoutSet);

      if (_exerciseSets[workoutExerciseId] == null) {
        _exerciseSets[workoutExerciseId] = [];
      }
      _exerciseSets[workoutExerciseId]!.add(created);

      notifyListeners();
      return created;
    } catch (e) {
      debugPrint('Error adding set: $e');
      return null;
    }
  }

  Future<void> updateSet(WorkoutSet workoutSet) async {
    try {
      await _dbService.updateWorkoutSet(workoutSet);

      final sets = _exerciseSets[workoutSet.workoutExerciseId];
      if (sets != null) {
        final index = sets.indexWhere((s) => s.id == workoutSet.id);
        if (index != -1) {
          sets[index] = workoutSet;
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating set: $e');
    }
  }

  Future<void> deleteSet(int setId, int workoutExerciseId) async {
    try {
      await _dbService.deleteWorkoutSet(setId);

      _exerciseSets[workoutExerciseId]?.removeWhere((s) => s.id == setId);

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting set: $e');
    }
  }

  Future<List<WorkoutExercise>> getWorkoutExercises(int workoutId) async {
    try {
      if (_workoutExercises[workoutId] == null) {
        _workoutExercises[workoutId] = await _dbService.getWorkoutExercises(workoutId);
      }
      return _workoutExercises[workoutId]!;
    } catch (e) {
      debugPrint('Error getting workout exercises: $e');
      return [];
    }
  }

  Future<List<WorkoutSet>> getExerciseSets(int workoutExerciseId) async {
    try {
      if (_exerciseSets[workoutExerciseId] == null) {
        _exerciseSets[workoutExerciseId] = await _dbService.getWorkoutSets(workoutExerciseId);
      }
      return _exerciseSets[workoutExerciseId]!;
    } catch (e) {
      debugPrint('Error getting exercise sets: $e');
      return [];
    }
  }

  Exercise? getExerciseById(int id) {
    try {
      return _exercises.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Exercise> getExercisesByCategory(String category) {
    return _exercises.where((e) => e.category == category).toList();
  }

  Future<Map<String, int>> getWorkoutStats() async {
    try {
      return await _dbService.getWorkoutStats();
    } catch (e) {
      debugPrint('Error getting workout stats: $e');
      return {'totalWorkouts': 0, 'thisWeekWorkouts': 0, 'totalSets': 0};
    }
  }
}
