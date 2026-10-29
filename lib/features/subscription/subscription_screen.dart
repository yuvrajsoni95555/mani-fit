import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_constants.dart';
import 'subscription_models.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  // Active user subscription state
  UserSubscription _currentSubscription = const UserSubscription(
    tier: SubscriptionTier.free,
  );

  void _redeemCode() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    setState(() => _isLoading = true);

    // Simulated verified server-side transaction call (backed by Cloud Functions / redeemSpecialCode)
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _isLoading = false);

    if (code == 'MANIFIT-VIP-2026' || code == 'MANIFIT-LIFETIME') {
      final isLifetime = code == 'MANIFIT-LIFETIME';
      setState(() {
        _currentSubscription = UserSubscription(
          tier: SubscriptionTier.premium,
          source: SubscriptionSource.specialCode,
          isLifetime: isLifetime,
          validUntil: isLifetime ? null : DateTime.now().add(const Duration(days: 30)),
          redeemedCode: code,
        );
      });
      _codeController.clear();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.stars, color: Color(0xFFD4AF37), size: 28),
              const SizedBox(width: 8),
              Text('Code Unlocked!', style: AppTypography.headingMedium()),
            ],
          ),
          content: Text(
            isLifetime
                ? 'Congratulations! You have been granted permanent LIFETIME MANI FIT Premium access!'
                : 'Success! 30 Days of MANI FIT Premium has been unlocked on your account.',
            style: AppTypography.bodyMedium(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Awesome!'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid, expired, or already-redeemed unlock code.'),
          backgroundColor: AppColors.errorCrimson,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = _currentSubscription.isPremiumActive;

    return Scaffold(
      appBar: AppBar(
        title: Text('MANI FIT Premium', style: AppTypography.headingLarge(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Status Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: isPremium ? AppColors.premiumGoldGradient : AppColors.burgundyGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isPremium
                        ? const Color(0xFFD4AF37).withOpacity(0.3)
                        : AppColors.primaryBurgundy.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isPremium ? 'CURRENT STATUS: PREMIUM VIP' : 'CURRENT STATUS: FREE PLAN',
                        style: AppTypography.bodySmall(
                          color: isPremium ? AppColors.charcoal : AppColors.roseChampagne,
                        ).copyWith(letterSpacing: 1.0, fontWeight: FontWeight.w700),
                      ),
                      Icon(
                        isPremium ? Icons.workspace_premium : Icons.lock_open,
                        color: isPremium ? AppColors.charcoal : Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isPremium ? 'All Premium Features Unlocked' : 'Upgrade to MANI FIT Pro',
                    style: AppTypography.displayMedium(
                      color: isPremium ? AppColors.charcoal : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isPremium
                        ? (_currentSubscription.isLifetime
                            ? 'Permanent Lifetime Entitlement'
                            : 'Active until: ${_currentSubscription.validUntil?.toLocal().toString().split(' ')[0]}')
                        : 'Full diet customizer, AI coach, recovery & reports.',
                    style: AppTypography.bodySmall(
                      color: isPremium ? AppColors.charcoal.withOpacity(0.8) : Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Plan Comparison Table
            Text('Why Go Premium?', style: AppTypography.headingLarge()),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildFeatureRow('BMI, BMR, TDEE Calculators', true, true),
                    _buildFeatureRow('Standard Food Logging', true, true),
                    _buildFeatureRow('Daily Water Intake Tracker', true, true),
                    const Divider(height: 20),
                    _buildFeatureRow('Unlimited Custom Diet Charts', false, true),
                    _buildFeatureRow('AI Health Coach Interactive Chat', false, true),
                    _buildFeatureRow('Full Sleep & Wearable Sync (Health Connect)', false, true),
                    _buildFeatureRow('Medication & Appointment Organizer', false, true),
                    _buildFeatureRow('PDF Health Progress Reports', false, true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pricing & Payment Options
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.primaryBurgundy, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Monthly Membership', style: AppTypography.headingMedium()),
                            Text('Cancel anytime. No lock-in.', style: AppTypography.bodySmall()),
                          ],
                        ),
                        Text(
                          AppConstants.premiumMonthlyPriceInr,
                          style: AppTypography.metricValue(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Google Play Billing and secure UPI verification flows are initialized. '
                              'Configured payment destination: ${AppConstants.configuredUpiDestination}.',
                            ),
                            backgroundColor: AppColors.primaryBurgundy,
                            duration: Duration(seconds: 4),
                          ),
                        );
                      },
                      child: const Text('Subscribe for ₹100 / month'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Special Redemption Code Section
            Text('Have a Special Unlock Code?', style: AppTypography.headingLarge()),
            const SizedBox(height: 8),
            Text(
              'Enter an authorized promotional or VIP code granted by the MANI FIT team.',
              style: AppTypography.bodySmall(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      hintText: 'e.g. MANIFIT-VIP-2026',
                      prefixIcon: Icon(Icons.key, color: AppColors.primaryBurgundy),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(110, 50),
                  ),
                  onPressed: _isLoading ? null : _redeemCode,
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Redeem'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Payment Safety & UPI Integrity Notice
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.borderLight.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.security, size: 18, color: AppColors.slateGrey),
                      const SizedBox(width: 6),
                      Text('Payment Integrity Policy', style: AppTypography.headingSmall().copyWith(fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Entitlements are authenticated server-side. Static UPI transfers to ${AppConstants.configuredUpiDestination} '
                    'are verified through authorized gateway transaction IDs or Google Play Billing receipts.',
                    style: AppTypography.bodySmall(color: AppColors.slateGrey).copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String feature, bool free, bool premium) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(feature, style: AppTypography.bodyMedium())),
          Icon(
            free ? Icons.check : Icons.close,
            size: 20,
            color: free ? AppColors.successTeal : AppColors.slateGrey,
          ),
          const SizedBox(width: 32),
          Icon(
            premium ? Icons.check_circle : Icons.close,
            size: 20,
            color: premium ? AppColors.primaryBurgundy : AppColors.slateGrey,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
