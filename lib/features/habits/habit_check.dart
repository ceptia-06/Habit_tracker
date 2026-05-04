class HabitCheck {
  final String id;
  final String habitId;
  final String userId;
  final String checkedDate;
  final DateTime createdAt;

  HabitCheck({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.checkedDate,
    required this.createdAt,
  });

  factory HabitCheck.fromJson(Map<String, dynamic> json) {
    final createdAtRaw = json['created_at'];
    final createdAt = createdAtRaw is String
        ? DateTime.parse(createdAtRaw).toUtc()
        : (createdAtRaw as DateTime).toUtc();

    return HabitCheck(
      id: json['id'] as String,
      habitId: json['habit_id'] as String,
      userId: json['user_id'] as String,
      checkedDate: json['checked_date'] as String,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habit_id': habitId,
      'user_id': userId,
      'checked_date': checkedDate,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }
}
