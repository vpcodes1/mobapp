class WorkoutSet {
  final int? id;
  final int workoutExerciseId;
  final int setNumber;
  final int reps;
  final double weight; // in kg
  final bool completed;
  final String? notes;
  final DateTime createdAt;

  WorkoutSet({
    this.id,
    required this.workoutExerciseId,
    required this.setNumber,
    required this.reps,
    required this.weight,
    this.completed = false,
    this.notes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workoutExerciseId': workoutExerciseId,
      'setNumber': setNumber,
      'reps': reps,
      'weight': weight,
      'completed': completed ? 1 : 0,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    return WorkoutSet(
      id: map['id'] as int?,
      workoutExerciseId: map['workoutExerciseId'] as int,
      setNumber: map['setNumber'] as int,
      reps: map['reps'] as int,
      weight: (map['weight'] as num).toDouble(),
      completed: (map['completed'] as int) == 1,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  WorkoutSet copyWith({
    int? id,
    int? workoutExerciseId,
    int? setNumber,
    int? reps,
    double? weight,
    bool? completed,
    String? notes,
    DateTime? createdAt,
  }) {
    return WorkoutSet(
      id: id ?? this.id,
      workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      completed: completed ?? this.completed,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
