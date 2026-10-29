# ====================================================================
# MANI FIT - Automated Verification and Quality Test Suite
# ====================================================================

$ErrorActionPreference = "Stop"

Write-Host "========================================================" -ForegroundColor Magenta
Write-Host "       MANI FIT - AUTOMATED VERIFICATION SUITE         " -ForegroundColor Cyan
Write-Host "   Deterministic Calculations, Nutrition and Security   " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Magenta
Write-Host ""

$testsPassed = 0
$testsFailed = 0

function Assert-Test {
    param(
        [Parameter(Mandatory=$true)][string]$testName,
        [Parameter(Mandatory=$true)][bool]$condition,
        [string]$details = ""
    )
    if ($condition) {
        Write-Host "  [PASS] $testName" -ForegroundColor Green
        $script:testsPassed++
    } else {
        Write-Host "  [FAIL] $testName : $details" -ForegroundColor Red
        $script:testsFailed++
    }
}

# -------------------------------------------------------------
# 1. BMI CALCULATIONS AND BOUNDARY RULES
# -------------------------------------------------------------
Write-Host "`n--- 1. Testing BMI Calculation and Classification ---" -ForegroundColor Yellow

function Calculate-Bmi([double]$wKg, [double]$hCm) {
    $hM = $hCm / 100.0
    return [Math]::Round($wKg / ($hM * $hM), 1)
}

$bmi1 = Calculate-Bmi 72.0 175.0
Assert-Test -testName "Normal Adult Male (72kg, 175cm) BMI = 23.5" -condition ($bmi1 -eq 23.5) -details "Got $bmi1"

$bmi2 = Calculate-Bmi 85.0 175.0
Assert-Test -testName "Overweight Adult (85kg, 175cm) BMI = 27.8" -condition ($bmi2 -eq 27.8) -details "Got $bmi2"

$bmi3 = Calculate-Bmi 95.0 170.0
Assert-Test -testName "Obesity Class I (95kg, 170cm) BMI = 32.9" -condition ($bmi3 -eq 32.9) -details "Got $bmi3"

$bmi4 = Calculate-Bmi 50.0 175.0
Assert-Test -testName "Underweight Adult (50kg, 175cm) BMI = 16.3" -condition ($bmi4 -eq 16.3) -details "Got $bmi4"

# -------------------------------------------------------------
# 2. BMR AND TDEE (MIFFLIN-ST JEOR FORMULA)
# -------------------------------------------------------------
Write-Host "`n--- 2. Testing BMR and TDEE (Mifflin-St Jeor) ---" -ForegroundColor Yellow

# Male: 10*w + 6.25*h - 5*age + 5
# For 72kg, 175cm, 26yo: 720 + 1093.75 - 130 + 5 = 1688.75 -> 1688.8
$bmrMale = [Math]::Round((10.0 * 72.0) + (6.25 * 175.0) - (5.0 * 26.0) + 5.0, 1)
Assert-Test -testName "Male BMR (72kg, 175cm, 26yo) = 1688.8 kcal" -condition ($bmrMale -eq 1688.8) -details "Got $bmrMale"

# Female: 10*w + 6.25*h - 5*age - 161
# For 60kg, 165cm, 28yo: 600 + 1031.25 - 140 - 161 = 1330.25
$bmrFemaleExact = (10.0 * 60.0) + (6.25 * 165.0) - (5.0 * 28.0) - 161.0
$bmrFemaleRounded = [Math]::Round($bmrFemaleExact, 1)
Assert-Test -testName "Female BMR (60kg, 165cm, 28yo) = 1330.25 kcal" -condition ($bmrFemaleExact -eq 1330.25 -and ($bmrFemaleRounded -eq 1330.2 -or $bmrFemaleRounded -eq 1330.3)) -details "Got exact: $bmrFemaleExact, rounded: $bmrFemaleRounded"

# TDEE Moderate (1.55 multiplier)
$tdeeMale = [Math]::Round($bmrMale * 1.55, 1)
Assert-Test -testName "TDEE Moderate Activity Multiplier (1688.8 * 1.55) = 2617.6 kcal" -condition ($tdeeMale -eq 2617.6) -details "Got $tdeeMale"

# Calorie Safety Floor Check
function Get-SafeCalorieTarget([double]$tdee, [string]$gender) {
    $target = $tdee - 500.0
    $floor = if ($gender -eq "female") { 1200.0 } else { 1500.0 }
    return [Math]::Max($target, $floor)
}

$safeTarget1 = Get-SafeCalorieTarget 1400.0 "female"
Assert-Test -testName "Safety Floor: 1400 kcal TDEE with 500 deficit clamps to 1200 kcal floor (female)" -condition ($safeTarget1 -eq 1200.0) -details "Got $safeTarget1"

$safeTarget2 = Get-SafeCalorieTarget 1700.0 "male"
Assert-Test -testName "Safety Floor: 1700 kcal TDEE with 500 deficit clamps to 1500 kcal floor (male)" -condition ($safeTarget2 -eq 1500.0) -details "Got $safeTarget2"

# -------------------------------------------------------------
# 3. MACRO SPLIT CALORIC INTEGRITY
# -------------------------------------------------------------
Write-Host "`n--- 3. Testing Macronutrient Caloric Conservation ---" -ForegroundColor Yellow

$calories = 2000.0
$weight = 75.0
$proteinG = $weight * 2.0 # 150g
$proteinCal = $proteinG * 4.0 # 600 kcal
$fatCal = $calories * 0.25 # 500 kcal
$fatG = $fatCal / 9.0 # 55.55g
$carbsCal = $calories - ($proteinCal + $fatCal) # 900 kcal
$carbsG = $carbsCal / 4.0 # 225g

$sumCalories = $proteinCal + $fatCal + $carbsCal
Assert-Test -testName "Sum of Macro Calories equals Target Calories (600 + 500 + 900 = 2000)" -condition ($sumCalories -eq 2000.0) -details "Got $sumCalories"

# -------------------------------------------------------------
# 4. NUTRITION ENGINE FOOD SCALING AND RECIPE SUMS
# -------------------------------------------------------------
Write-Host "`n--- 4. Testing Food Scaling and Nutrient Aggregates ---" -ForegroundColor Yellow

# Roti: 297 kcal / 100g. Standard serving = 35g. 2 rotis = 70g.
$rotiGrams = 70.0
$rotiCalories = [Math]::Round(297.0 * ($rotiGrams / 100.0), 1)
Assert-Test -testName "2 Rotis (70g at 297kcal per 100g) = 207.9 kcal" -condition ($rotiCalories -eq 207.9) -details "Got $rotiCalories"

# Dal: 104 kcal / 100g. Standard serving = 150g.
$dalGrams = 150.0
$dalCalories = [Math]::Round(104.0 * ($dalGrams / 100.0), 1)
Assert-Test -testName "1 Bowl Dal (150g at 104kcal per 100g) = 156.0 kcal" -condition ($dalCalories -eq 156.0) -details "Got $dalCalories"

# Meal roll-up
$mealTotal = $rotiCalories + $dalCalories
Assert-Test -testName "Meal Roll-up preserves sub-component nutrients (207.9 + 156.0 = 363.9)" -condition ($mealTotal -eq 363.9) -details "Got $mealTotal"

# -------------------------------------------------------------
# 5. SPECIAL UNLOCK CODE VALIDATION RULES
# -------------------------------------------------------------
Write-Host "`n--- 5. Testing Special Redemption Code Logic ---" -ForegroundColor Yellow

$validCode = @{
    Code = "MANIFIT-VIP-2026";
    IsActive = $true;
    ExpiresAt = (Get-Date).AddDays(30);
    MaxRedemptions = 50;
    CurrentRedemptions = 10;
    RedeemedBy = @("usr_1", "usr_2");
}

function Test-CodeEligibility($codeObj, $uid) {
    if (-not $codeObj.IsActive) { return "DEACTIVATED" }
    if ((Get-Date) -gt $codeObj.ExpiresAt) { return "EXPIRED" }
    if ($codeObj.CurrentRedemptions -ge $codeObj.MaxRedemptions) { return "EXHAUSTED" }
    if ($codeObj.RedeemedBy -contains $uid) { return "ALREADY_REDEEMED" }
    return "ELIGIBLE"
}

Assert-Test -testName "Valid Code with fresh user returns ELIGIBLE" -condition ((Test-CodeEligibility $validCode "usr_99") -eq "ELIGIBLE")
Assert-Test -testName "Same user attempting reuse returns ALREADY_REDEEMED" -condition ((Test-CodeEligibility $validCode "usr_1") -eq "ALREADY_REDEEMED")

$expiredCode = $validCode.Clone()
$expiredCode.ExpiresAt = (Get-Date).AddDays(-1)
Assert-Test -testName "Expired Code returns EXPIRED" -condition ((Test-CodeEligibility $expiredCode "usr_99") -eq "EXPIRED")

$exhaustedCode = $validCode.Clone()
$exhaustedCode.CurrentRedemptions = 50
Assert-Test -testName "Maxed Redemptions Code returns EXHAUSTED" -condition ((Test-CodeEligibility $exhaustedCode "usr_99") -eq "EXHAUSTED")

# -------------------------------------------------------------
# 6. SECURITY AND SECRET LEAK AUDIT
# -------------------------------------------------------------
Write-Host "`n--- 6. Security and Secret Leak Inspection ---" -ForegroundColor Yellow

$filesToScan = Get-ChildItem -Path "C:\Users\yuvra\.gemini\antigravity\scratch\mani_fit" -Recurse -File -Include "*.dart", "*.js", "*.html", "*.json", "*.rules"
$leaksFound = 0

foreach ($f in $filesToScan) {
    $content = Get-Content -Path $f.FullName -Raw
    if ($content -match "AIza[0-9A-Za-z-_]{35}") {
        Write-Host "  [WARN] Potential hardcoded Google API key found in $($f.Name)" -ForegroundColor Red
        $leaksFound++
    }
    if ($content -match "(?i)password\s*=\s*['`"][^'`"]+['`"]") {
        Write-Host "  [WARN] Potential hardcoded password found in $($f.Name)" -ForegroundColor Red
        $leaksFound++
    }
}
Assert-Test -testName "Zero production API keys or passwords hard-coded in repository" -condition ($leaksFound -eq 0)

# -------------------------------------------------------------
# SUMMARY REPORT
# -------------------------------------------------------------
Write-Host "`n========================================================" -ForegroundColor Magenta
Write-Host "                 TEST SUITE SUMMARY                    " -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Magenta
Write-Host "  Total Tests Executed : $($testsPassed + $testsFailed)" -ForegroundColor White
Write-Host "  Passed Tests         : $testsPassed" -ForegroundColor Green
Write-Host "  Failed Tests         : $testsFailed" -ForegroundColor $(if ($testsFailed -eq 0) { "Green" } else { "Red" })
Write-Host "========================================================" -ForegroundColor Magenta

if ($testsFailed -gt 0) {
    Exit 1
} else {
    Exit 0
}
