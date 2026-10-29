# MANI FIT — Special Unlock Code Administration

## 1. Overview
The Special Unlock Code system allows authorized administrators to create, issue, and manage promotional and VIP access codes for selected individuals.

---

## 2. Supported Entitlement Types

| Entitlement Code | Duration | Purpose |
| :--- | :--- | :--- |
| `monthly_30d` | 30 Days | Beta tester passes, monthly VIP rewards |
| `quarterly_90d` | 90 Days | Influencer alliances, corporate challenges |
| `annual_365d` | 365 Days | Annual partner access |
| `lifetime` | Permanent | Founding team, VIP lifetime ambassadors |

---

## 3. Creating & Managing Codes via Admin Console

1. Open `admin/index.html` in your web browser.
2. Navigate to the **Special Unlock Codes** tab.
3. Fill in:
   - **Code Value**: Uppercase alphanumeric string (e.g. `MANIFIT-VIP-2026`).
   - **Entitlement Type**: Select duration.
   - **Max Allowable Uses**: 1 (single-use) up to 1,000 (batch promo).
   - **Expiration Date**: Calendar cutoff date.
   - **Internal Notes**: Audit note describing intended recipient.
4. Click **Generate & Save Code**.
5. To deactivate a code prematurely, click **Revoke** in the active table.

---

## 4. Server-Side Atomic Redemption Workflow

When a user submits a code:
1. Client calls `redeemSpecialCode({ code: '...' })` Cloud Function.
2. Server validates authentication, sanitizes the code, and begins a Firestore transaction.
3. Server verifies:
   - `isActive == true`
   - `now < expiresAt`
   - `currentRedemptions < maxRedemptions`
   - `!redeemedByUids.includes(uid)`
4. Atomically increments `currentRedemptions` by 1 and adds user's UID to `redeemedByUids`.
5. Updates `users/{uid}.subscription` with the granted entitlement.
6. Writes an append-only event to `audit_logs`.
