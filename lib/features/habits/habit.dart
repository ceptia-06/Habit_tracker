class Habit {
  final String id;
  final String userId;
  final String name;
  final DateTime createdAt;

  Habit({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    final createdAtRaw = json['created_at'];
    final createdAt = createdAtRaw is String
        ? DateTime.parse(createdAtRaw).toUtc()
        : (createdAtRaw as DateTime).toUtc();

    return Habit(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }
}
