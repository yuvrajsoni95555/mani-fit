import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import 'organizer_models.dart';

class OrganizerScreen extends StatefulWidget {
  const OrganizerScreen({super.key});

  @override
  State<OrganizerScreen> createState() => _OrganizerScreenState();
}

class _OrganizerScreenState extends State<OrganizerScreen> {
  final List<MedicationItem> _medications = [
    const MedicationItem(
      id: 'med_1',
      name: 'Vitamin D3 (Cholecalciferol)',
      dosage: '60,000 IU',
      instructions: 'Take once weekly with fatty meal',
      scheduleTimes: ['Sunday 10:00 AM'],
      isReminderActive: true,
      prescribedBy: 'Annual Wellness Review',
    ),
    const MedicationItem(
      id: 'med_2',
      name: 'Omega-3 Fish Oil',
      dosage: '1000 mg (EPA 500mg, DHA 250mg)',
      instructions: 'Take 1 softgel daily after dinner',
      scheduleTimes: ['09:00 PM'],
      isReminderActive: true,
    ),
  ];

  final List<HealthAppointment> _appointments = [
    HealthAppointment(
      id: 'apt_1',
      providerName: 'Dr. A. Sharma (Sports Medicine)',
      specialty: 'Shoulder Mobility & Routine Assessment',
      scheduledAt: DateTime.now().add(const Duration(days: 4, hours: 3)),
      locationOrLink: 'Apollo Health City, Room 304',
      notes: 'Bring previous MRI report and blood panel results.',
      isConfirmedByProvider: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Organizer', style: AppTypography.headingLarge(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notice Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.lightPink,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.primaryBurgundy, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This is a personal schedule organizer. It does not prescribe medications or verify clinic bookings automatically.',
                      style: AppTypography.bodySmall(color: AppColors.deepBurgundy).copyWith(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Medications Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Medications & Supplements', style: AppTypography.headingLarge()),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: AppColors.primaryBurgundy),
                  tooltip: 'Add Entry',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add Medication modal opened.')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._medications.map((med) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBurgundy.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.medication, color: AppColors.primaryBurgundy),
                  ),
                  title: Text(med.name, style: AppTypography.headingSmall()),
                  subtitle: Text(
                    '${med.dosage} • ${med.instructions}\nTime: ${med.scheduleTimes.join(", ")}',
                    style: AppTypography.bodySmall(),
                  ),
                  trailing: Switch(
                    value: med.isReminderActive,
                    activeColor: AppColors.primaryBurgundy,
                    onChanged: (val) {},
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),

            // Appointments Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Scheduled Appointments', style: AppTypography.headingLarge()),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: AppColors.primaryBurgundy),
                  tooltip: 'Add Appointment',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add Appointment modal opened.')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._appointments.map((apt) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(apt.providerName, style: AppTypography.headingMedium()),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: apt.isConfirmedByProvider ? AppColors.lightPink : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              apt.isConfirmedByProvider ? 'Confirmed' : 'Pending Confirmation',
                              style: AppTypography.bodySmall(
                                color: apt.isConfirmedByProvider ? AppColors.primaryBurgundy : AppColors.slateGrey,
                              ).copyWith(fontWeight: FontWeight.w600, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(apt.specialty, style: AppTypography.bodySmall(color: AppColors.slateGrey)),
                      const Divider(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: AppColors.primaryBurgundy),
                          const SizedBox(width: 6),
                          Text(
                            apt.scheduledAt.toLocal().toString().split('.')[0],
                            style: AppTypography.bodyMedium().copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: AppColors.slateGrey),
                          const SizedBox(width: 6),
                          Text(apt.locationOrLink, style: AppTypography.bodySmall()),
                        ],
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
