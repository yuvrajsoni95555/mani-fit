class DrinkEntry {
  final String id;
  final DateTime timestamp;
  final int amountMl;

  const DrinkEntry({
    required this.id,
    required this.timestamp,
    required this.amountMl,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'amountMl': amountMl,
      };

  factory DrinkEntry.fromMap(Map<String, dynamic> map) => DrinkEntry(
        id: map['id'] as String,
        timestamp: DateTime.parse(map['timestamp'] as String),
        amountMl: map['amountMl'] as int,
      );
}

class HydrationDaySummary {
  final DateTime date;
  final int targetMl;
  final List<DrinkEntry> entries;

  const HydrationDaySummary({
    required this.date,
    this.targetMl = 2500,
    required this.entries,
  });

  int get totalConsumedMl => entries.fold(0, (sum, e) => sum + e.amountMl);
  double get progressPercentage => (targetMl > 0) ? (totalConsumedMl / targetMl).clamp(0.0, 1.0) : 0.0;
  int get remainingMl => (targetMl - totalConsumedMl).clamp(0, targetMl);

  Map<String, dynamic> toMap() => {
        'date': date.toIso8601String(),
        'targetMl': targetMl,
        'entries': entries.map((e) => e.toMap()).toList(),
        'totalConsumedMl': totalConsumedMl,
        'progressPercentage': progressPercentage,
      };
}
