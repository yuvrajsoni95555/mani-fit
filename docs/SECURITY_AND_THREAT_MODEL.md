# MANI FIT — Security, Threat Model & Wellness Safety Review

## 1. Threat Model & Practical Safeguards

| Threat Vector | Risk Level | Architectural Mitigation |
| :--- | :--- | :--- |
| **Client-Side Entitlement Tampering** | High | Client applications have zero authority to grant subscriptions. Firestore rules prohibit clients from modifying `users.subscription`. All changes must pass through atomic serverless Cloud Functions. |
| **Code Brute-Forcing & Enumeration** | High | The `redemption_codes` collection is strictly locked to `isAdmin()`. Standard clients cannot read or list documents in this collection. Cloud Functions enforce rate-limiting. |
| **Cross-User Data Leaks** | High | All health, nutrition, workout, and appointment subcollections enforce `isOwner(userId)` (`request.auth.uid == userId`). |
| **Payment Spoofing** | High | Webhook transactions require digital signature verification (`x-mani-fit-signature`). Receipts are verified with payment providers before activating entitlements. |
| **Medical Liability & Dangerous Advice** | High | Calculators enforce hard clinical safety floors (1,200 kcal female, 1,500 kcal male). Prominent disclaimers remind users that MANI FIT is educational and does not replace medical supervision. AI prompts strictly forbid disease diagnosis or drug prescriptions. |

---

## 2. Privacy & Data Minimization
- No personally identifiable health data is shared with third-party advertising trackers.
- Users can export all personal data via `ReportGeneratorService.exportPersonalUserData()` in structured JSON.
- Account deletion purges all associated Firestore subcollections and storage assets.
