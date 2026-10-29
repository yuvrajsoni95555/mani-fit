import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_constants.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  // Demo State (linked to state providers in live Riverpod store)
  int _waterConsumedMl = 1750;
  final int _waterTargetMl = 2500;
  final int _targetCalories = 1950;
  final int _consumedCalories = 1380;

  void _addWater(int ml) {
    setState(() {
      _waterConsumedMl = (_waterConsumedMl + ml).clamp(0, 5000);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged +${ml}ml of water! Total: $_waterConsumedMl ml'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.successTeal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final caloriesRemaining = _targetCalories - _consumedCalories;
    final waterProgress = (_waterConsumedMl / _waterTargetMl).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(AppConstants.appName, style: AppTypography.headingLarge(color: Colors.white)),
            Text(
              AppConstants.appTagline,
              style: AppTypography.bodySmall(color: AppColors.roseChampagne).copyWith(fontSize: 10),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star, color: Color(0xFFF3E5AB)),
            tooltip: 'Premium Status',
            onPressed: () => context.push('/subscription'),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: 'Organizer & Reminders',
            onPressed: () => context.push('/organizer'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header & Quick Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello, Athlete!', style: AppTypography.displayMedium()),
                    Text(
                      'Ready to crush your daily milestones?',
                      style: AppTypography.bodyMedium(color: AppColors.slateGrey),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => context.push('/subscription'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: AppColors.premiumGoldGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4AF37).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.workspace_premium, size: 16, color: AppColors.charcoal),
                        const SizedBox(width: 4),
                        Text(
                          'PREMIUM',
                          style: AppTypography.bodySmall(color: AppColors.charcoal).copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Hero Calorie Ring & Target Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: AppColors.burgundyGradient,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DAILY CALORIE BUDGET',
                              style: AppTypography.bodySmall(color: AppColors.roseChampagne).copyWith(
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$caloriesRemaining kcal',
                              style: AppTypography.displayLarge(color: Colors.white),
                            ),
                            Text(
                              'remaining of $_targetCalories target',
                              style: AppTypography.bodySmall(color: Colors.white70),
                            ),
                          ],
                        ),
                        // Circular Energy Indicator
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 72,
                              height: 72,
                              child: CircularProgressIndicator(
                                value: (_consumedCalories / _targetCalories).clamp(0.0, 1.0),
                                strokeWidth: 8,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.roseChampagne),
                              ),
                            ),
                            Text(
                              '${((_consumedCalories / _targetCalories) * 100).toInt()}%',
                              style: AppTypography.headingSmall(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 28),

                    // Macro Splits Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMacroPill('Protein', '118g / 140g', 0.84, Colors.white),
                        _buildMacroPill('Carbs', '145g / 210g', 0.69, AppColors.roseChampagne),
                        _buildMacroPill('Fat', '38g / 52g', 0.73, AppColors.lightPink),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions: Diet Chart Maker & AI Coach
            Row(
              children: [
                Expanded(
                  child: _buildActionTile(
                    title: 'Diet Chart',
                    subtitle: 'Create & edit plans',
                    icon: Icons.restaurant_menu,
                    color: AppColors.primaryBurgundy,
                    onTap: () => context.go('/diet-charts'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionTile(
                    title: 'AI Coach',
                    subtitle: 'Ask fitness advisor',
                    icon: Icons.psychology,
                    color: AppColors.deepBurgundy,
                    onTap: () => context.go('/ai-coach'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Hydration Tracker Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.water_drop, color: AppColors.successTeal, size: 24),
                            const SizedBox(width: 8),
                            Text('Hydration Target', style: AppTypography.headingMedium()),
                          ],
                        ),
                        Text(
                          '$_waterConsumedMl / $_waterTargetMl ml',
                          style: AppTypography.headingSmall(color: AppColors.successTeal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: waterProgress,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                      backgroundColor: AppColors.lightPink.withOpacity(0.4),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.successTeal),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildWaterButton('+250 ml', () => _addWater(250)),
                        _buildWaterButton('+500 ml', () => _addWater(500)),
                        _buildWaterButton('+750 ml', () => _addWater(750)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Activity & Steps (Health Connect / Sensor integration)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.directions_walk, color: AppColors.primaryBurgundy, size: 24),
                            const SizedBox(width: 8),
                            Text('Activity & Steps', style: AppTypography.headingMedium()),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.lightPink,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Health Connect Ready',
                            style: AppTypography.bodySmall(color: AppColors.deepBurgundy).copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricColumn('Steps', '7,420', 'Goal: 10,000'),
                        _buildMetricColumn('Active Cal', '380 kcal', 'Burned'),
                        _buildMetricColumn('Sleep', '7h 20m', 'Rest score: 85'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroPill(String label, String value, double progress, Color color) {
    return Column(
      children: [
        Text(label, style: AppTypography.bodySmall(color: Colors.white70)),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.bodySmall(color: color).copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        SizedBox(
          width: 60,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: AppColors.charcoal.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.headingSmall()),
                  Text(subtitle, style: AppTypography.bodySmall()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterButton(String text, VoidCallback onPressed) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(80, 36),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        side: const BorderSide(color: AppColors.successTeal),
      ),
      onPressed: onPressed,
      child: Text(text, style: AppTypography.bodySmall(color: AppColors.successTeal).copyWith(fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildMetricColumn(String label, String value, String sub) {
    return Column(
      children: [
        Text(value, style: AppTypography.headingMedium(color: AppColors.primaryBurgundy)),
        Text(label, style: AppTypography.bodySmall(color: AppColors.charcoal)),
        Text(sub, style: AppTypography.bodySmall(color: AppColors.slateGrey).copyWith(fontSize: 10)),
      ],
    );
  }
}
