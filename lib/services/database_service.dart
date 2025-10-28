import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../models/workout_exercise.dart';
import '../models/workout_set.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fitness_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    // Exercises table
    await db.execute('''
      CREATE TABLE exercises (
        id $idType,
        name $textType,
        category $textType,
        description TEXT,
        imageUrl TEXT,
        createdAt $textType
      )
    ''');

    // Workouts table
    await db.execute('''
      CREATE TABLE workouts (
        id $idType,
        name $textType,
        startTime $textType,
        endTime TEXT,
        notes TEXT,
        completed $intType
      )
    ''');

    // Workout exercises table (junction table)
    await db.execute('''
      CREATE TABLE workout_exercises (
        id $idType,
        workoutId $intType,
        exerciseId $intType,
        orderIndex $intType,
        notes TEXT,
        createdAt $textType,
        FOREIGN KEY (workoutId) REFERENCES workouts (id) ON DELETE CASCADE,
        FOREIGN KEY (exerciseId) REFERENCES exercises (id) ON DELETE CASCADE
      )
    ''');

    // Workout sets table
    await db.execute('''
      CREATE TABLE workout_sets (
        id $idType,
        workoutExerciseId $intType,
        setNumber $intType,
        reps $intType,
        weight $realType,
        completed $intType,
        notes TEXT,
        createdAt $textType,
        FOREIGN KEY (workoutExerciseId) REFERENCES workout_exercises (id) ON DELETE CASCADE
      )
    ''');

    // Insert some default exercises
    await _insertDefaultExercises(db);
  }

  Future<void> _insertDefaultExercises(Database db) async {
    final exercises = [
      // Chest
      {'name': 'Bench Press', 'category': 'chest'},
      {'name': 'Incline Bench Press', 'category': 'chest'},
      {'name': 'Dumbbell Flyes', 'category': 'chest'},
      {'name': 'Push-ups', 'category': 'chest'},

      // Back
      {'name': 'Deadlift', 'category': 'back'},
      {'name': 'Pull-ups', 'category': 'back'},
      {'name': 'Barbell Row', 'category': 'back'},
      {'name': 'Lat Pulldown', 'category': 'back'},

      // Legs
      {'name': 'Squat', 'category': 'legs'},
      {'name': 'Leg Press', 'category': 'legs'},
      {'name': 'Lunges', 'category': 'legs'},
      {'name': 'Leg Curl', 'category': 'legs'},
      {'name': 'Calf Raises', 'category': 'legs'},

      // Shoulders
      {'name': 'Overhead Press', 'category': 'shoulders'},
      {'name': 'Lateral Raises', 'category': 'shoulders'},
      {'name': 'Front Raises', 'category': 'shoulders'},

      // Arms
      {'name': 'Bicep Curl', 'category': 'arms'},
      {'name': 'Tricep Extension', 'category': 'arms'},
      {'name': 'Hammer Curl', 'category': 'arms'},
      {'name': 'Tricep Dips', 'category': 'arms'},

      // Core
      {'name': 'Plank', 'category': 'core'},
      {'name': 'Crunches', 'category': 'core'},
      {'name': 'Russian Twists', 'category': 'core'},

      // Cardio
      {'name': 'Running', 'category': 'cardio'},
      {'name': 'Cycling', 'category': 'cardio'},
      {'name': 'Jump Rope', 'category': 'cardio'},
    ];

    for (var exercise in exercises) {
      await db.insert('exercises', {
        'name': exercise['name'],
        'category': exercise['category'],
        'description': null,
        'imageUrl': null,
        'createdAt': DateTime.now().toIso8601String(),
      });
    }
  }

  // Exercise CRUD operations
  Future<Exercise> createExercise(Exercise exercise) async {
    final db = await instance.database;
    final id = await db.insert('exercises', exercise.toMap());
    return exercise.copyWith(id: id);
  }

  Future<List<Exercise>> getAllExercises() async {
    final db = await instance.database;
    final result = await db.query('exercises', orderBy: 'name ASC');
    return result.map((json) => Exercise.fromMap(json)).toList();
  }

  Future<List<Exercise>> getExercisesByCategory(String category) async {
    final db = await instance.database;
    final result = await db.query(
      'exercises',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'name ASC',
    );
    return result.map((json) => Exercise.fromMap(json)).toList();
  }

  // Workout CRUD operations
  Future<Workout> createWorkout(Workout workout) async {
    final db = await instance.database;
    final id = await db.insert('workouts', workout.toMap());
    return workout.copyWith(id: id);
  }

  Future<Workout?> getWorkout(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'workouts',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Workout.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Workout>> getAllWorkouts() async {
    final db = await instance.database;
    final result = await db.query('workouts', orderBy: 'startTime DESC');
    return result.map((json) => Workout.fromMap(json)).toList();
  }

  Future<List<Workout>> getRecentWorkouts({int limit = 10}) async {
    final db = await instance.database;
    final result = await db.query(
      'workouts',
      orderBy: 'startTime DESC',
      limit: limit,
    );
    return result.map((json) => Workout.fromMap(json)).toList();
  }

  Future<int> updateWorkout(Workout workout) async {
    final db = await instance.database;
    return db.update(
      'workouts',
      workout.toMap(),
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }

  Future<int> deleteWorkout(int id) async {
    final db = await instance.database;
    return await db.delete(
      'workouts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Workout Exercise operations
  Future<WorkoutExercise> createWorkoutExercise(WorkoutExercise workoutExercise) async {
    final db = await instance.database;
    final id = await db.insert('workout_exercises', workoutExercise.toMap());
    return workoutExercise.copyWith(id: id);
  }

  Future<List<WorkoutExercise>> getWorkoutExercises(int workoutId) async {
    final db = await instance.database;
    final result = await db.query(
      'workout_exercises',
      where: 'workoutId = ?',
      whereArgs: [workoutId],
      orderBy: 'orderIndex ASC',
    );
    return result.map((json) => WorkoutExercise.fromMap(json)).toList();
  }

  // Workout Set operations
  Future<WorkoutSet> createWorkoutSet(WorkoutSet workoutSet) async {
    final db = await instance.database;
    final id = await db.insert('workout_sets', workoutSet.toMap());
    return workoutSet.copyWith(id: id);
  }

  Future<List<WorkoutSet>> getWorkoutSets(int workoutExerciseId) async {
    final db = await instance.database;
    final result = await db.query(
      'workout_sets',
      where: 'workoutExerciseId = ?',
      whereArgs: [workoutExerciseId],
      orderBy: 'setNumber ASC',
    );
    return result.map((json) => WorkoutSet.fromMap(json)).toList();
  }

  Future<int> updateWorkoutSet(WorkoutSet workoutSet) async {
    final db = await instance.database;
    return db.update(
      'workout_sets',
      workoutSet.toMap(),
      where: 'id = ?',
      whereArgs: [workoutSet.id],
    );
  }

  Future<int> deleteWorkoutSet(int id) async {
    final db = await instance.database;
    return await db.delete(
      'workout_sets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Analytics queries
  Future<Map<String, int>> getWorkoutStats() async {
    final db = await instance.database;

    final totalWorkouts = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM workouts WHERE completed = 1')
    ) ?? 0;

    final thisWeekWorkouts = Sqflite.firstIntValue(
      await db.rawQuery('''
        SELECT COUNT(*) FROM workouts
        WHERE completed = 1
        AND startTime >= datetime('now', '-7 days')
      ''')
    ) ?? 0;

    final totalSets = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM workout_sets WHERE completed = 1')
    ) ?? 0;

    return {
      'totalWorkouts': totalWorkouts,
      'thisWeekWorkouts': thisWeekWorkouts,
      'totalSets': totalSets,
    };
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
