# MANI FIT — Payment, Subscription & Entitlement Architecture

## 1. Subscription Strategy

- **Target Plan**: Premium Monthly Membership
- **Target Price**: **₹100 per month** (inclusive of applicable taxes and regional fees)
- **Features Unlocked**:
  - Unlimited custom Diet Charts & weekly meal plans
  - Interactive AI Fitness Coach (powered by Gemini)
  - Full sleep, recovery & wearable integration (Health Connect)
  - Medication & doctor appointment organizer
  - Exportable clinical-grade PDF progress reports

---

## 2. Platform Compliance & Payment Options

### 2.1 Google Play Store Distribution
Google Play policies mandate that digital subscriptions and content unlocked inside Android apps distributed via the Play Store MUST utilize **Google Play Billing**.
- Direct UPI links, UPI intent prompts, or external payment forms cannot be presented inside a Play Store build for digital content without violating Play Policy.
- SKU ID configured: `mani_fit_premium_monthly_100inr`.

### 2.2 External / Sideloaded / Web Distribution
For direct web subscriptions or third-party distribution where permitted by applicable local regulations:
- The configured UPI destination is:
  `yuvrajsoni95555-1@okaxis`
- **Critical Security Policy**:
  A static UPI ID or receipt screenshot alone does NOT prove payment, establish an automatic recurring mandate, or grant subscription access.
  MANI FIT utilizes a verified server-to-server webhook endpoint (`confirmPaymentWebhook` in `backend/functions/index.js`) to validate transaction IDs, check provider digital signatures (`x-mani-fit-signature`), and update user entitlements atomically.

---

## 3. Entitlement Verification (Zero-Trust Architecture)

1. Client apps NEVER determine subscription access based on local flags or editable storage.
2. Premium gates check `user.subscription.tier == 'premium'` AND (`validUntil > now` OR `isLifetime == true`).
3. Firestore Security Rules enforce that standard clients cannot alter the `subscription` map on `users/{userId}` documents. Only authorized serverless Cloud Functions or verified administrators can elevate a user's subscription tier.
