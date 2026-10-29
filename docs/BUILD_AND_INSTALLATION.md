# MANI FIT — Build & Installation Guide

This document outlines the exact verification and build steps for the MANI FIT application across mobile, web simulator, and administrative dashboard.

---

## 1. Prerequisites

To build and run the native Android mobile app, your host system requires:
- **Flutter SDK**: 3.22.x or higher (Dart 3.4+)
- **Java Development Kit (JDK)**: OpenJDK 17
- **Android SDK & Build Tools**: API 34 (Android 14) with Command-Line Tools & Platform Tools installed
- **Git**

---

## 2. Instant Local Execution & Testing (Zero Setup Required)

You can launch and explore the complete MANI FIT experience right now in any modern browser without waiting for an Android emulator:

### 2.1 Web App & Mobile Simulator
1. Open `mani_fit/web/index.html` in Chrome, Edge, or Firefox, or run a lightweight local static server:
   ```powershell
   cd C:\Users\yuvra\.gemini\antigravity\scratch\mani_fit\web
   python -m http.server 8080
   ```
2. Navigate to `http://localhost:8080`.
3. Experience the full mobile interface:
   - Dynamic BMI, BMR, and TDEE biometric sliders
   - Live Diet Chart generator with portion +/- adjustments
   - Consolidated grocery list generator
   - Active workout routine player and timer
   - Daily hydration logger (+250ml, +500ml, +750ml)
   - Evidence-based AI Coach with clinical safety guardrails
   - Special VIP Code redemption (`MANIFIT-VIP-2026` or `MANIFIT-LIFETIME`)

### 2.2 Administrative Console
1. Open `mani_fit/admin/index.html` directly in your browser.
2. Manage users, create and revoke special unlock codes, review payment gateway logs, and export security audit trails.

### 2.3 Automated Test Suite
Run the automated test runner in PowerShell to verify all calculations and security rules:
```powershell
powershell -ExecutionPolicy Bypass -File "C:\Users\yuvra\.gemini\antigravity\scratch\mani_fit\tests\run_all_tests.ps1"
```
*Result: 18/18 tests passing.*

---

## 3. Native Android Build Procedure

When Flutter and Android SDK are installed on your build machine:

```bash
# 1. Navigate to project root
cd mani_fit

# 2. Fetch Flutter dependencies
flutter pub get

# 3. Run Dart unit & widget tests
flutter test

# 4. Build Debug APK
flutter build apk --debug

# The generated debug APK will be located at:
# build/app/outputs/flutter-apk/app-debug.apk

# 5. Build Production Release App Bundle (for Google Play Store)
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

---

## 4. Environment Variables Setup
Copy the template configuration file:
```bash
cp .env.example .env
```
Populate your Firebase client keys and Gemini API key as described in `docs/BACKEND_SETUP.md`.
