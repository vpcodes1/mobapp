class Exercise {
  final int? id;
  final String name;
  final String category; // chest, back, legs, shoulders, arms, core, cardio
  final String? description;
  final String? imageUrl;
  final DateTime createdAt;

  Exercise({
    this.id,
    required this.name,
    required this.category,
    this.description,
    this.imageUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: map['category'] as String,
      description: map['description'] as String?,
      imageUrl: map['imageUrl'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Exercise copyWith({
    int? id,
    String? name,
    String? category,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
