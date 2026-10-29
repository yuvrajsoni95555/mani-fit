class MedicationItem {
  final String id;
  final String name; // e.g. "Vitamin D3", "Omega-3", "Prescribed Multivitamin"
  final String dosage; // e.g. "1 capsule", "500 mg"
  final String instructions; // e.g. "Take with breakfast", "Take after food"
  final List<String> scheduleTimes; // e.g. ["09:00 AM"]
  final bool isReminderActive;
  final String? prescribedBy;

  const MedicationItem({
    required this.id,
    required this.name,
    required this.dosage,
    required this.instructions,
    required this.scheduleTimes,
    this.isReminderActive = true,
    this.prescribedBy,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'dosage': dosage,
        'instructions': instructions,
        'scheduleTimes': scheduleTimes,
        'isReminderActive': isReminderActive,
        'prescribedBy': prescribedBy,
      };

  factory MedicationItem.fromMap(Map<String, dynamic> map) => MedicationItem(
        id: map['id'] as String,
        name: map['name'] as String,
        dosage: map['dosage'] as String,
        instructions: map['instructions'] as String,
        scheduleTimes: List<String>.from(map['scheduleTimes'] ?? []),
        isReminderActive: (map['isReminderActive'] as bool?) ?? true,
        prescribedBy: map['prescribedBy'] as String?,
      );
}

class HealthAppointment {
  final String id;
  final String providerName; // e.g. "Dr. Sharma", "Apollo Clinic"
  final String specialty; // e.g. "Sports Medicine", "General Physician", "Nutritionist"
  final DateTime scheduledAt;
  final String locationOrLink;
  final String notes;
  final bool isConfirmedByProvider;

  const HealthAppointment({
    required this.id,
    required this.providerName,
    required this.specialty,
    required this.scheduledAt,
    required this.locationOrLink,
    required this.notes,
    this.isConfirmedByProvider = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'providerName': providerName,
        'specialty': specialty,
        'scheduledAt': scheduledAt.toIso8601String(),
        'locationOrLink': locationOrLink,
        'notes': notes,
        'isConfirmedByProvider': isConfirmedByProvider,
      };

  factory HealthAppointment.fromMap(Map<String, dynamic> map) => HealthAppointment(
        id: map['id'] as String,
        providerName: map['providerName'] as String,
        specialty: map['specialty'] as String,
        scheduledAt: DateTime.parse(map['scheduledAt'] as String),
        locationOrLink: map['locationOrLink'] as String,
        notes: map['notes'] as String,
        isConfirmedByProvider: (map['isConfirmedByProvider'] as bool?) ?? false,
      );
}
