# MANI FIT — Backend Architecture & Deployment Guide

## 1. Selected Primary Backend: Firebase

### 1.1 Why Firebase?
Firebase was selected as the primary backend for MANI FIT after evaluating free-tier limits, SDK maturity, and development velocity:
- **Free-Tier Limits (Spark Plan)**:
  - **Firestore**: 50,000 document reads/day, 20,000 writes/day, 20,000 deletes/day, 1 GiB total storage.
  - **Authentication**: Unlimited Email/Password, Anonymous, and Google Sign-In; 10,000 phone OTP authentications/month.
  - **Cloud Functions**: 2,000,000 invocations/month.
  - **Hosting**: 10 GB storage, 360 MB/day data transfer.
- **Cross-Platform Native Support**: First-class Flutter plugins (`firebase_core`, `cloud_firestore`, `firebase_auth`, `cloud_functions`).
- **Zero Fixed Infrastructure Cost**: True serverless architecture scaling down to ₹0 when idle.

### 1.2 Dual-Backend Readiness: Supabase Alternative
For organizations prioritizing an open-source relational PostgreSQL stack:
- Complete relational schema and RLS policies are available in `backend/supabase/schema.sql`.
- Supabase free tier offers 500 MB database storage, 50,000 monthly active users, and 5 GB bandwidth.
- Stored procedure `public.redeem_code(p_code)` handles row-locked atomic code redemption.

---

## 2. Deploying Firebase Backend

### 2.1 Install Firebase CLI
```bash
npm install -g firebase-tools
firebase login
```

### 2.2 Initialize Project
```bash
cd mani_fit
firebase use --add <YOUR_FIREBASE_PROJECT_ID>
```

### 2.3 Deploy Security Rules
```bash
firebase deploy --only firestore:rules
```
*The deployed rules in `firestore.rules` enforce multi-layer RBAC, user isolation, immutable field protection, and admin-only access on codes and audit logs.*

### 2.4 Deploy Cloud Functions
```bash
cd backend/functions
npm install
firebase deploy --only functions
```
This deploys:
1. `redeemSpecialCode`: Handles atomic server-side code validation, user binding, and entitlement updates.
2. `confirmPaymentWebhook`: Handles signed payment gateway callbacks.
