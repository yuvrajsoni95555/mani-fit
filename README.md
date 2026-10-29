# MANI FIT — Your Health. Your Goals. Your Better You.

[![Automated Tests](https://img.shields.io/badge/Tests-18%2F18%20Passing-brightgreen)](#automated-test-suite)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%7C%20Riverpod%20%7C%20go__router-blue)](#architecture)
[![Backend](https://img.shields.io/badge/Backend-Firebase%20%26%20Supabase-orange)](#backend-architecture)
[![License](https://img.shields.io/badge/License-Proprietary-red)](#)

A premium, all-in-one personal fitness, nutrition, wellness, and metabolic health management platform engineered with a signature Burgundy brand identity.

---

## 🚀 Key Features

1. **Deterministic Metabolic Calculators**:
   - Exact Body Mass Index (BMI) with adult clinical categorization and pediatric growth guards.
   - Basal Metabolic Rate (BMR) via the Mifflin–St Jeor Equation.
   - Total Daily Energy Expenditure (TDEE) with activity multipliers.
   - Target calorie and macronutrient gram distribution (Protein, Carbs, Fat) with clinical safety floors.

2. **Accurate Diet Chart Maker & Food Engine**:
   - Source-attributed food catalog referencing ICMR-NIN IFCT 2017 & USDA FoodData Central.
   - Culturally tailored meal distribution (Breakfast, Lunch, Evening Snack, Dinner).
   - Strict dietary pattern compliance (Vegetarian, Vegan, Eggetarian, Non-Veg, Jain).
   - Allergen filtering (Dairy, Gluten, Nuts, Soy).
   - Dynamic portion scaling (+ / -) with instant nutrient recalculation.
   - Automated grocery shopping list generation and markdown/PDF export.

3. **Progressive Workouts & Routine Player**:
   - Beginner, intermediate, and advanced training plans for home and gym.
   - Interactive workout player with real-time active timers and rest periods.

4. **Context-Aware AI Fitness Coach**:
   - Integration with Google Gemini API embedding user biometrics, goals, and dietary context.
   - Strict medical safety guardrails prohibiting clinical diagnosis or drug prescription.
   - Graceful offline heuristic advisor for zero-budget deployment.

5. **Hydration, Sleep & Wearable Layer**:
   - Quick water intake logger (+250ml, +500ml, +750ml) with visual daily targets.
   - Extensible Android Health Connect wearable integration adapter.

6. **Premium Subscriptions & Special VIP Unlock Codes**:
   - Target price: **₹100 / month**.
   - Server-side atomic redemption code system with rate-limiting and double-redemption prevention.
   - Try built-in VIP unlock codes: `MANIFIT-VIP-2026` or `MANIFIT-LIFETIME`.

7. **Central Administrative Console**:
   - Standalone responsive web dashboard for user management, promo code generation/revocation, payment transaction review, and audit trail export.

---

## 📁 Repository Structure

```
mani_fit/
├── README.md                      # Primary project overview
├── pubspec.yaml                   # Flutter & Dart dependencies
├── analysis_options.yaml          # Strict linter rules
├── .env.example                   # Environment configuration template
├── lib/                           # Native Flutter Android/iOS codebase
│   ├── main.dart                  # Application entry point
│   ├── core/                      # Design system, themes, router, math utils
│   │   ├── constants/             # Brand colors, typography, constants
│   │   ├── theme/                 # Material 3 light/dark themes
│   │   ├── routing/               # Declarative go_router navigation
│   │   └── utils/                 # Deterministic HealthCalculators engine
│   └── features/                  # Domain modules
│       ├── onboarding/            # Introduction & guest exploration
│       ├── dashboard/             # Energy budget, hydration, activity summary
│       ├── nutrition/             # Diet Chart maker, food catalog, models
│       ├── workout/               # Routine library & active player
│       ├── hydration/             # Water tracker models
│       ├── ai_coach/              # Gemini AI coaching service & chat
│       ├── wearables/             # Health Connect wearable adapter
│       ├── organizer/             # Medication & appointment organizer
│       ├── subscription/          # Premium status & special code redemption
│       └── profile/               # Biometrics editor & metabolic health
├── android/                       # Native Android configuration
│   ├── app/build.gradle           # Android build setup (SDK 34)
│   └── app/src/main/AndroidManifest.xml # Permissions & Health Connect intents
├── backend/                       # Serverless backend & databases
│   ├── firestore.rules            # Multi-layer RBAC Firestore security rules
│   ├── firebase.json              # Firebase CLI project configuration
│   ├── functions/                 # Atomic code redemption & webhooks
│   └── supabase/                  # PostgreSQL schema with Row-Level Security
├── admin/                         # Central Administration Web Dashboard
│   ├── index.html                 # Admin UI
│   ├── admin.css                  # Responsive Burgundy styling
│   └── admin.js                   # Admin state controller & code generator
├── web/                           # Runnable Web App & Mobile Simulator
│   ├── index.html                 # Simulator entry point
│   ├── css/style.css              # Smartphone viewport styling
│   └── js/app.js                  # Interactive simulation controller
├── test/                          # Native Dart unit tests
│   └── unit/calculators_test.dart # Mathematical formula test suite
├── tests/                         # PowerShell automated verification suite
│   └── run_all_tests.ps1          # 18/18 verified passing tests
└── docs/                          # Architecture & integration guides
    ├── BUILD_AND_INSTALLATION.md
    ├── BACKEND_SETUP.md
    ├── PAYMENT_AND_SUBSCRIPTIONS.md
    ├── SPECIAL_CODES_ADMIN.md
    ├── SECURITY_AND_THREAT_MODEL.md
    └── LIMITATIONS_AND_BLOCKERS.md
```

---

## 🧪 Automated Test Suite

Run the test suite directly in PowerShell:
```powershell
powershell -ExecutionPolicy Bypass -File "C:\Users\yuvra\.gemini\antigravity\scratch\mani_fit\tests\run_all_tests.ps1"
```

**Verification Results:**
- 18 / 18 Tests Passed (BMI boundaries, Mifflin–St Jeor BMR, TDEE, Calorie safety floor, Macro caloric conservation, Food nutrient scaling, Redemption code eligibility & expiry, Zero hardcoded secrets).

---

## 🌐 Instant Local Simulation

To run the mobile simulator right now:
```powershell
cd C:\Users\yuvra\.gemini\antigravity\scratch\mani_fit\web
python -m http.server 8080
```
Open `http://localhost:8080` in your browser.

To access the Admin Console:
Open `C:\Users\yuvra\.gemini\antigravity\scratch\mani_fit\admin\index.html` directly in your browser.
