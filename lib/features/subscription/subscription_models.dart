enum SubscriptionTier {
  free,
  premium,
}

enum SubscriptionSource {
  none,
  googlePlay,
  upiVerification,
  specialCode,
}

enum CodeEntitlementType {
  monthly30Days,
  quarterly90Days,
  annual365Days,
  lifetime,
}

class UserSubscription {
  final SubscriptionTier tier;
  final SubscriptionSource source;
  final DateTime? validUntil;
  final bool isLifetime;
  final String? transactionReference;
  final String? redeemedCode;

  const UserSubscription({
    required this.tier,
    this.source = SubscriptionSource.none,
    this.validUntil,
    this.isLifetime = false,
    this.transactionReference,
    this.redeemedCode,
  });

  bool get isPremiumActive {
    if (isLifetime) return true;
    if (tier == SubscriptionTier.premium && validUntil != null) {
      return validUntil!.isAfter(DateTime.now());
    }
    return false;
  }

  int get remainingDays {
    if (isLifetime) return 99999;
    if (validUntil == null) return 0;
    final diff = validUntil!.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  Map<String, dynamic> toMap() => {
        'tier': tier.name,
        'source': source.name,
        'validUntil': validUntil?.toIso8601String(),
        'isLifetime': isLifetime,
        'transactionReference': transactionReference,
        'redeemedCode': redeemedCode,
        'isPremiumActive': isPremiumActive,
      };

  factory UserSubscription.fromMap(Map<String, dynamic> map) {
    return UserSubscription(
      tier: SubscriptionTier.values.firstWhere(
        (e) => e.name == map['tier'],
        orElse: () => SubscriptionTier.free,
      ),
      source: SubscriptionSource.values.firstWhere(
        (e) => e.name == map['source'],
        orElse: () => SubscriptionSource.none,
      ),
      validUntil: map['validUntil'] != null ? DateTime.parse(map['validUntil'] as String) : null,
      isLifetime: (map['isLifetime'] as bool?) ?? false,
      transactionReference: map['transactionReference'] as String?,
      redeemedCode: map['redeemedCode'] as String?,
    );
  }
}

class SpecialRedemptionCode {
  final String code; // e.g. "MANIFIT-VIP-2026"
  final CodeEntitlementType entitlement;
  final int maxRedemptions;
  final int currentRedemptions;
  final DateTime expiresAt;
  final bool isActive;
  final List<String> redeemedByUids;
  final String notes;

  const SpecialRedemptionCode({
    required this.code,
    required this.entitlement,
    required this.maxRedemptions,
    required this.currentRedemptions,
    required this.expiresAt,
    required this.isActive,
    required this.redeemedByUids,
    required this.notes,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isExhausted => currentRedemptions >= maxRedemptions;
  bool isEligibleForUser(String uid) => isActive && !isExpired && !isExhausted && !redeemedByUids.contains(uid);

  Map<String, dynamic> toMap() => {
        'code': code,
        'entitlement': entitlement.name,
        'maxRedemptions': maxRedemptions,
        'currentRedemptions': currentRedemptions,
        'expiresAt': expiresAt.toIso8601String(),
        'isActive': isActive,
        'redeemedByUids': redeemedByUids,
        'notes': notes,
      };
}
