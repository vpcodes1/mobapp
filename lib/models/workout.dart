class Workout {
  final int? id;
  final String name;
  final DateTime startTime;
  final DateTime? endTime;
  final String? notes;
  final bool completed;

  Workout({
    this.id,
    required this.name,
    DateTime? startTime,
    this.endTime,
    this.notes,
    this.completed = false,
  }) : startTime = startTime ?? DateTime.now();

  Duration? get duration {
    if (endTime != null) {
      return endTime!.difference(startTime);
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'notes': notes,
      'completed': completed ? 1 : 0,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'] as int?,
      name: map['name'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime'] as String) : null,
      notes: map['notes'] as String?,
      completed: (map['completed'] as int) == 1,
    );
  }

  Workout copyWith({
    int? id,
    String? name,
    DateTime? startTime,
    DateTime? endTime,
    String? notes,
    bool? completed,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      notes: notes ?? this.notes,
      completed: completed ?? this.completed,
    );
  }
}
