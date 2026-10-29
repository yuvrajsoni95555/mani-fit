# MANI FIT — Known Limitations & Remaining External Blockers

## 1. External Dependencies Requiring Account Owner Authorization

As an autonomous agent, all independent software architecture, code implementation, test automation, admin consoles, and local simulators have been delivered. The following items strictly require user-owned external accounts or physical devices:

| Item | Required External Action | Shortest Resolution Path | Status |
| :--- | :--- | :--- | :--- |
| **Google Play Developer Account** | Registration of app package `com.manifit.app` and activation of ₹100/mo subscription in Play Console. | Create account at `play.google.com/console`, accept developer terms, and upload `app-release.aab`. | Interface ready; awaiting owner credentials |
| **Firebase Cloud Project** | Link production Firebase project to deploy `firestore.rules` and Cloud Functions. | Run `firebase login`, select your project, and run `firebase deploy`. | Rules and functions ready to deploy |
| **Gemini AI API Key** | Account owner API key from Google AI Studio. | Obtain free API key from `aistudio.google.com` and set `GEMINI_API_KEY` in `.env`. | Graceful heuristic fallback active |
| **Physical Android Device** | Physical device with Android 14+ for live step counter and sensor sync. | Connect physical device via ADB to verify Google Health Connect permissions. | Adapter interface & simulator functional |

---

## 2. Technical Limitations & Disclaimers

1. **Static UPI Transactions**:
   The configured UPI ID (`yuvrajsoni95555-1@okaxis`) serves as a payment destination for authorized gateway callbacks. Static peer-to-peer UPI transfers do not emit automated webhooks to client apps; automated subscriptions require integration with an approved payment aggregator (e.g. Razorpay, Cashfree, or Google Play Billing).
2. **Camera Calorie Estimation**:
   Photo food recognition provides approximate volume and ingredient heuristics. It cannot detect hidden fats or internal salt levels without scale weighing.
3. **General Wellness Scope**:
   MANI FIT is designed as a wellness and habit-building companion, not a medical device. Clinical nutrition for chronic conditions requires qualified medical supervision.
