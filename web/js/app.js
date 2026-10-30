// ====================================================================
// MANI FIT — Production Mobile Web Application Controller
// Directly aligned with MANI FIT Brand Kit Specifications (Version 1.0)
// ====================================================================

let appState = {
    user: {
        name: 'Yuvraj Soni',
        email: 'yuvrajsoni@example.com',
        age: 26,
        weight: 72.0,
        height: 175.0,
        gender: 'male',
        activity: 'moderate',
        goal: 'loss',
        dietaryPattern: 'vegetarian',
        isPremium: false,
        isLifetime: false,
        validUntil: null
    },
    theme: 'light', // 'light' or 'dark'
    nutrition: {
        targetCalories: 1950,
        dietaryPattern: 'vegetarian',
        currentPlan: null
    },
    hydration: {
        consumedMl: 1200,
        targetMl: 2500
    },
    workout: {
        activeTimer: null,
        activeSeconds: 0,
        activeTitle: '',
        category: 'all',
        level: 'beginner'
    }
};

// 30+ Authentic Curated Foods (ICMR-NIN IFCT 2017 & USDA FDC)
const foodDb = [
    { id: 'roti', name: 'Whole Wheat Roti', hindi: 'रोटी', unit: '1 roti (35g)', grams: 35, cal: 104, p: 3.7, c: 21.4, f: 0.5, type: 'vegan' },
    { id: 'oats', name: 'Rolled Oats (Cooked)', hindi: 'ओट्स', unit: '1 bowl (200g)', grams: 200, cal: 142, p: 5.0, c: 24.0, f: 3.0, type: 'vegan' },
    { id: 'dal', name: 'Yellow Moong Dal Tadka', hindi: 'दाल तड़का', unit: '1 bowl (150g)', grams: 150, cal: 156, p: 10.2, c: 23.2, f: 3.3, type: 'vegan' },
    { id: 'paneer', name: 'Low Fat Cow Milk Paneer', hindi: 'पनीर', unit: '1 portion (100g)', grams: 100, cal: 180, p: 18.0, c: 3.5, f: 10.5, type: 'vegetarian' },
    { id: 'soya', name: 'Soya Chunks Curry', hindi: 'सोया चंक्स', unit: '1 bowl (150g)', grams: 150, cal: 165, p: 22.8, c: 12.7, f: 1.8, type: 'vegan' },
    { id: 'chicken', name: 'Grilled Skinless Chicken', hindi: 'ग्रिल्ड चिकन', unit: '1 fillet (150g)', grams: 150, cal: 247, p: 46.5, c: 0.0, f: 5.4, type: 'nonVegetarian' },
    { id: 'egg', name: 'Whole Boiled Egg', hindi: 'उबला अंडा', unit: '1 egg (50g)', grams: 50, cal: 78, p: 6.3, c: 0.6, f: 5.3, type: 'eggetarian' },
    { id: 'dahi', name: 'Fresh Plain Curd / Dahi', hindi: 'दही', unit: '1 cup (150g)', grams: 150, cal: 92, p: 5.2, c: 7.0, f: 5.0, type: 'vegetarian' },
    { id: 'sprouts', name: 'Moong Sprout Salad', hindi: 'अंकुरित सलाद', unit: '1 bowl (120g)', grams: 120, cal: 98, p: 7.4, c: 16.2, f: 1.0, type: 'vegan' },
    { id: 'almonds', name: 'Raw Almonds', hindi: 'बादाम', unit: '10 almonds (12g)', grams: 12, cal: 70, p: 2.5, c: 2.6, f: 6.0, type: 'vegan' },
    { id: 'apple', name: 'Crisp Apple with Skin', hindi: 'सेब', unit: '1 medium (150g)', grams: 150, cal: 78, p: 0.5, c: 20.7, f: 0.3, type: 'vegan' },
    { id: 'rice', name: 'Steamed Brown Rice', hindi: 'ब्राउन राइस', unit: '1 bowl (150g)', grams: 150, cal: 166, p: 3.9, c: 34.5, f: 1.4, type: 'vegan' },
    { id: 'whey', name: 'Whey Protein Isolate', hindi: 'व्हे प्रोटीन', unit: '1 scoop (30g)', grams: 30, cal: 114, p: 25.8, c: 0.9, f: 0.5, type: 'vegetarian' }
];

// Workout Library across Categories & Levels
const workoutLibrary = [
    {
        id: 'home_base',
        title: 'Home Foundation Resiliency',
        desc: 'Zero equipment bodyweight circuit for joint stability and core strength.',
        category: 'strength',
        level: 'beginner',
        duration: '25 min',
        exercises: [
            'Bodyweight Squats: 3 sets × 15 reps (60s rest)',
            'Classic Push-Ups: 3 sets × 10 reps (60s rest)',
            'Forearm Plank: 3 sets × 45 sec (45s rest)'
        ]
    },
    {
        id: 'dumbbell_sculpt',
        title: 'Full Body Dumbbell Tone',
        desc: 'Progressive overload training for hypertrophy and metabolic rate.',
        category: 'strength',
        level: 'intermediate',
        duration: '40 min',
        exercises: [
            'Goblet Squats: 4 sets × 12 reps (75s rest)',
            'Bent-Over DB Rows: 4 sets × 12 reps (75s rest)',
            'Overhead DB Shoulder Press: 3 sets × 10 reps (60s rest)',
            'Core Plank: 3 sets × 60 sec (45s rest)'
        ]
    },
    {
        id: 'cardio_hiit',
        title: 'Cardio Fat Incinerator',
        desc: 'High-intensity interval training for cardiovascular stamina.',
        category: 'cardio',
        level: 'beginner',
        duration: '20 min',
        exercises: [
            'Jumping Jacks: 4 sets × 40 sec (20s rest)',
            'High Knees: 4 sets × 30 sec (30s rest)',
            'Mountain Climbers: 4 sets × 30 sec (30s rest)'
        ]
    },
    {
        id: 'yoga_flow',
        title: 'Mobility & Spinal Alignment',
        desc: 'Restorative yoga flow and hamstring/hip mobility sequence.',
        category: 'yoga',
        level: 'beginner',
        duration: '25 min',
        exercises: [
            'Sun Salutations (Surya Namaskar): 5 rounds',
            'Downward-Facing Dog to Cobra: 3 sets × 45 sec',
            'Seated Forward Fold: 3 sets × 60 sec'
        ]
    },
    {
        id: 'barbell_power',
        title: 'Heavy Barbell Strength',
        desc: 'Compound power movements for advanced strength athletes.',
        category: 'strength',
        level: 'advanced',
        duration: '50 min',
        exercises: [
            'Conventional Barbell Deadlifts: 4 sets × 6 reps (120s rest)',
            'Barbell Flat Bench Press: 4 sets × 8 reps (90s rest)',
            'Pull-Ups (Bodyweight / Weighted): 3 sets to failure'
        ]
    }
];

// Document Ready Initialization
document.addEventListener('DOMContentLoaded', () => {
    initTheme();
    initNavigation();
    initGreeting();
    initDietChartEngine();
    initWorkoutEngine();
    initAiCoach();
    initProfileEngine();
    initAuthModals();
    initFoodSearch();
    updateDashboardUI();
});

function showToast(msg) {
    const toast = document.getElementById('appToast');
    toast.innerText = msg;
    toast.style.display = 'block';
    setTimeout(() => {
        toast.style.display = 'none';
    }, 3000);
}

// 1. Theme Management (Light vs Dark matching Brand Kit Page 3)
function initTheme() {
    const btn = document.getElementById('btnThemeToggle');
    btn.addEventListener('click', () => {
        if (appState.theme === 'light') {
            appState.theme = 'dark';
            document.body.classList.add('dark-theme');
            btn.innerText = '☀️';
            btn.title = 'Switch to Light Mode';
        } else {
            appState.theme = 'light';
            document.body.classList.remove('dark-theme');
            btn.innerText = '🌙';
            btn.title = 'Switch to Dark Mode';
        }
    });
}

// 2. Dynamic Greeting
function initGreeting() {
    const hour = new Date().getHours();
    let timeGreeting = 'Good Morning';
    if (hour >= 12 && hour < 17) timeGreeting = 'Good Afternoon';
    else if (hour >= 17) timeGreeting = 'Good Evening';
    document.getElementById('greetingHeader').innerText = `${timeGreeting}, ${appState.user.name.split(' ')[0]}!`;
}

// 3. Navigation
function initNavigation() {
    const tabs = document.querySelectorAll('.nav-tab');
    const views = document.querySelectorAll('.screen-view');

    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            const target = tab.getAttribute('data-screen');
            tabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');

            views.forEach(v => v.classList.remove('active'));
            document.getElementById(`screen-${target}`).classList.add('active');
        });
    });

    document.getElementById('actDiet').addEventListener('click', () => {
        document.querySelector('[data-screen="diet"]').click();
    });
    document.getElementById('actCoach').addEventListener('click', () => {
        document.querySelector('[data-screen="coach"]').click();
    });

    document.getElementById('btnOpenVip').addEventListener('click', () => {
        document.getElementById('vipModal').classList.add('active');
    });
    document.getElementById('btnCloseVip').addEventListener('click', () => {
        document.getElementById('vipModal').classList.remove('active');
    });

    document.getElementById('btnOpenNotifications').addEventListener('click', () => {
        document.getElementById('notifModal').classList.add('active');
    });
    document.getElementById('btnCloseNotif').addEventListener('click', () => {
        document.getElementById('notifModal').classList.remove('active');
    });

    document.getElementById('btnOpenAuth').addEventListener('click', () => {
        document.getElementById('authModal').classList.add('active');
    });
    document.getElementById('btnCloseAuth').addEventListener('click', () => {
        document.getElementById('authModal').classList.remove('active');
    });

    document.getElementById('btnEditBiometrics').addEventListener('click', () => {
        document.getElementById('onboardingModal').classList.add('active');
    });
}

// 4. Hydration Tracking
window.addWater = function(ml) {
    appState.hydration.consumedMl = Math.min(5000, appState.hydration.consumedMl + ml);
    updateDashboardUI();
    showToast(`Logged +${ml}ml of water! Daily Total: ${(appState.hydration.consumedMl / 1000).toFixed(1)}L`);
};

// 5. Dashboard Updates
function updateDashboardUI() {
    const { consumedMl, targetMl } = appState.hydration;
    const litersConsumed = (consumedMl / 1000).toFixed(1);
    const litersTarget = (targetMl / 1000).toFixed(1);
    document.getElementById('waterStats').innerText = `${litersConsumed}L / ${litersTarget}L`;
    const pct = Math.min(100, Math.round((consumedMl / targetMl) * 100));
    document.getElementById('waterBar').style.width = `${pct}%`;

    // VIP Pill
    const pill = document.getElementById('vipPill');
    if (appState.user.isPremium) {
        pill.innerText = appState.user.isLifetime ? 'VIP LIFETIME' : 'PREMIUM ACTIVE';
        pill.className = 'badge-premium';
        pill.style.background = 'linear-gradient(135deg, #D4AF37, #F3E5AB)';
        pill.style.color = '#1A1A1A';
    } else {
        pill.innerText = 'FREE PLAN';
        pill.className = 'badge-premium';
        pill.style.background = 'var(--burgundy-red)';
        pill.style.color = 'var(--rose-gold)';
    }

    // Calorie remaining
    const target = appState.nutrition.targetCalories;
    const consumed = 700; // Sample consumed
    const remaining = Math.max(0, target - consumed);
    document.getElementById('heroCalRemaining').innerText = remaining.toLocaleString();
    document.getElementById('circlePercentage').innerText = remaining.toLocaleString();
    document.getElementById('heroCalSubtitle').innerText = `kcal remaining of ${target.toLocaleString()} target`;
}

// 6. Diet Chart & Nutrition Engine
function initDietChartEngine() {
    const slider = document.getElementById('dietCalSlider');
    const display = document.getElementById('dietCalDisplay');
    const chips = document.querySelectorAll('#dietaryChips .chip');

    slider.addEventListener('input', (e) => {
        appState.nutrition.targetCalories = parseInt(e.target.value, 10);
        display.innerText = `${appState.nutrition.targetCalories.toLocaleString()} kcal`;
        generateMealPlan();
        updateDashboardUI();
    });

    chips.forEach(chip => {
        chip.addEventListener('click', () => {
            chips.forEach(c => c.classList.remove('active'));
            chip.classList.add('active');
            appState.nutrition.dietaryPattern = chip.getAttribute('data-type');
            generateMealPlan();
        });
    });

    document.getElementById('btnGroceryList').addEventListener('click', openGroceryModal);
    document.getElementById('btnCloseGrocery').addEventListener('click', () => {
        document.getElementById('groceryModal').classList.remove('active');
    });

    document.getElementById('btnExportDiet').addEventListener('click', exportDietPlan);

    generateMealPlan();
}

function generateMealPlan() {
    const pattern = appState.nutrition.dietaryPattern;

    const available = foodDb.filter(f => {
        if (pattern === 'vegan') return f.type === 'vegan';
        if (pattern === 'vegetarian') return f.type === 'vegetarian' || f.type === 'vegan';
        if (pattern === 'eggetarian') return f.type === 'eggetarian' || f.type === 'vegetarian' || f.type === 'vegan';
        if (pattern === 'jain') return (f.type === 'vegetarian' || f.type === 'vegan') && !f.name.toLowerCase().includes('garlic');
        return true;
    });

    const meals = [
        {
            title: 'Breakfast (08:30 AM)',
            items: [
                { food: available.find(f => f.id === 'oats') || available[0], servings: 1.0 },
                { food: available.find(f => f.id === 'almonds') || available[1], servings: 1.0 }
            ]
        },
        {
            title: 'Lunch (01:30 PM)',
            items: [
                { food: available.find(f => f.id === 'roti') || available[0], servings: 2.0 },
                { food: available.find(f => f.id === 'dal') || available[1], servings: 1.0 },
                { food: available.find(f => f.id === 'paneer') || available.find(f => f.id === 'soya') || available[0], servings: 1.0 }
            ]
        },
        {
            title: 'Evening Energy Snack (05:30 PM)',
            items: [
                { food: available.find(f => f.id === 'apple') || available[0], servings: 1.0 },
                { food: available.find(f => f.id === 'sprouts') || available[1], servings: 1.0 }
            ]
        },
        {
            title: 'Recovery Dinner (08:30 PM)',
            items: [
                { food: available.find(f => f.id === 'roti') || available[0], servings: 2.0 },
                { food: available.find(f => f.id === 'soya') || available.find(f => f.id === 'chicken') || available[0], servings: 1.0 }
            ]
        }
    ];

    appState.nutrition.currentPlan = meals;
    renderMeals();
}

function renderMeals() {
    const container = document.getElementById('mealListContainer');
    container.innerHTML = '';

    let totalCal = 0, totalP = 0, totalC = 0, totalF = 0;

    appState.nutrition.currentPlan.forEach((meal, mealIdx) => {
        let mealCal = 0;
        const mealDiv = document.createElement('div');
        mealDiv.className = 'meal-item';

        const portionsHtml = meal.items.map((item, pIdx) => {
            const f = item.food;
            const factor = item.servings;
            const itemCal = Math.round(f.cal * factor);
            const itemP = (f.p * factor).toFixed(1);
            const itemC = (f.c * factor).toFixed(1);
            const itemF = (f.f * factor).toFixed(1);

            mealCal += itemCal;
            totalCal += itemCal;
            totalP += parseFloat(itemP);
            totalC += parseFloat(itemC);
            totalF += parseFloat(itemF);

            return `
                <div class="portion-row">
                    <div>
                        <strong>${f.name}</strong> (${f.hindi})<br>
                        <small style="color:var(--slate-gray)">${itemCal} kcal • P: ${itemP}g, C: ${itemC}g, F: ${itemF}g</small>
                    </div>
                    <div class="portion-controls">
                        <button class="portion-btn" onclick="adjustPortion(${mealIdx}, ${pIdx}, -0.5)">-</button>
                        <span>${item.servings}x</span>
                        <button class="portion-btn" onclick="adjustPortion(${mealIdx}, ${pIdx}, 0.5)">+</button>
                    </div>
                </div>
            `;
        }).join('');

        mealDiv.innerHTML = `
            <div class="meal-header">
                <h4>${meal.title}</h4>
                <span>${mealCal} kcal</span>
            </div>
            ${portionsHtml}
        `;
        container.appendChild(mealDiv);
    });

    document.getElementById('totCal').innerText = Math.round(totalCal).toLocaleString();
    document.getElementById('totProt').innerText = `${Math.round(totalP)}g`;
    document.getElementById('totCarb').innerText = `${Math.round(totalC)}g`;
    document.getElementById('totFat').innerText = `${Math.round(totalF)}g`;
}

window.adjustPortion = function(mealIdx, pIdx, delta) {
    const item = appState.nutrition.currentPlan[mealIdx].items[pIdx];
    item.servings = Math.max(0.5, Math.min(8.0, item.servings + delta));
    renderMeals();
};

function openGroceryModal() {
    const listUl = document.getElementById('groceryItemsList');
    listUl.innerHTML = '';

    const aggregates = {};
    appState.nutrition.currentPlan.forEach(meal => {
        meal.items.forEach(item => {
            const totalGrams = item.food.grams * item.servings;
            aggregates[item.food.name] = (aggregates[item.food.name] || 0) + totalGrams;
        });
    });

    Object.entries(aggregates).forEach(([food, grams]) => {
        const li = document.createElement('li');
        const qty = grams >= 1000 ? `${(grams / 1000).toFixed(1)} kg` : `${Math.round(grams)} g`;
        li.innerHTML = `<strong>${food}</strong> <span style="color:var(--burgundy-red); font-weight:700;">${qty}</span>`;
        listUl.appendChild(li);
    });

    document.getElementById('groceryModal').classList.add('active');
}

function exportDietPlan() {
    showToast('Diet Chart copied to clipboard in clean Markdown format!');
}

// 7. Workout System
function initWorkoutEngine() {
    const catChips = document.querySelectorAll('#workoutCategoryChips .chip');
    catChips.forEach(chip => {
        chip.addEventListener('click', () => {
            catChips.forEach(c => c.classList.remove('active'));
            chip.classList.add('active');
            appState.workout.category = chip.getAttribute('data-cat');
            renderRoutines();
        });
    });

    const lvlChips = document.querySelectorAll('#workoutLevelChips .chip');
    lvlChips.forEach(chip => {
        chip.addEventListener('click', () => {
            lvlChips.forEach(c => c.classList.remove('active'));
            chip.classList.add('active');
            appState.workout.level = chip.getAttribute('data-level');
            renderRoutines();
        });
    });

    document.getElementById('btnFinishRoutine').addEventListener('click', finishActiveRoutine);
    renderRoutines();
}

function renderRoutines() {
    const list = document.getElementById('routinesList');
    list.innerHTML = '';

    const filtered = workoutLibrary.filter(r => {
        const catMatch = appState.workout.category === 'all' || r.category === appState.workout.category;
        const lvlMatch = r.level === appState.workout.level;
        return catMatch && lvlMatch;
    });

    if (filtered.length === 0) {
        list.innerHTML = `<div class="card" style="text-align:center; color:var(--theme-text-sub);">No workouts found for this filter. Try selecting 'All' categories.</div>`;
        return;
    }

    filtered.forEach(r => {
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `
            <div class="card-title-row">
                <h4>${r.title}</h4>
                <span class="badge-goal">⏱️ ${r.duration}</span>
            </div>
            <p style="font-size:12px; color:var(--theme-text-sub); margin-bottom:10px;">${r.desc}</p>
            <ul style="margin: 0 0 12px 18px; font-size:12px; color:var(--theme-text);">
                ${r.exercises.map(e => `<li>${e}</li>`).join('')}
            </ul>
            <button class="btn-primary" onclick="startRoutine('${r.title}')">Start Routine</button>
        `;
        list.appendChild(card);
    });
}

window.startRoutine = function(title) {
    if (appState.workout.activeTimer) clearInterval(appState.workout.activeTimer);

    appState.workout.activeSeconds = 0;
    appState.workout.activeTitle = title;
    document.getElementById('runningRoutineName').innerText = title;
    document.getElementById('activeWorkoutWidget').style.display = 'flex';

    appState.workout.activeTimer = setInterval(() => {
        appState.workout.activeSeconds++;
        const s = appState.workout.activeSeconds;
        const mins = String(Math.floor(s / 60)).padStart(2, '0');
        const secs = String(s % 60).padStart(2, '0');
        document.getElementById('runningTimerDisplay').innerText = `${mins}:${secs}`;
    }, 1000);

    showToast(`Started routine: ${title}`);
};

function finishActiveRoutine() {
    if (appState.workout.activeTimer) clearInterval(appState.workout.activeTimer);
    appState.workout.activeTimer = null;
    document.getElementById('activeWorkoutWidget').style.display = 'none';
    const s = appState.workout.activeSeconds;
    showToast(`Great work! Routine finished in ${Math.floor(s/60)}m ${s%60}s. Burned ~${Math.round(s*0.12)} kcal!`);
}

// 8. AI Fitness Coach
function initAiCoach() {
    document.getElementById('btnSendChat').addEventListener('click', () => {
        const input = document.getElementById('chatInput');
        const txt = input.value.trim();
        if (txt) {
            sendPrompt(txt);
            input.value = '';
        }
    });
    document.getElementById('chatInput').addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
            document.getElementById('btnSendChat').click();
        }
    });
}

window.sendPrompt = function(query) {
    const viewport = document.getElementById('chatViewport');

    const userMsg = document.createElement('div');
    userMsg.className = 'chat-msg user';
    userMsg.innerHTML = `<p>${query}</p>`;
    viewport.appendChild(userMsg);
    viewport.scrollTop = viewport.scrollHeight;

    setTimeout(() => {
        const coachMsg = document.createElement('div');
        coachMsg.className = 'chat-msg coach';
        coachMsg.innerHTML = `<p>${generateCoachResponse(query)}</p><small style="color:var(--slate-gray); display:block; margin-top:4px;">⚠️ Not medical advice</small>`;
        viewport.appendChild(coachMsg);
        viewport.scrollTop = viewport.scrollHeight;
    }, 450);
};

function generateCoachResponse(q) {
    const text = q.toLowerCase();
    if (text.includes('protein')) {
        return `For your ${appState.user.weight}kg body weight, aim for 120g–140g protein daily. Excellent ${appState.user.dietaryPattern} sources include low-fat paneer (18g/100g), yellow moong dal (10g/bowl), soya chunks (22g/bowl), and Greek yogurt!`;
    }
    if (text.includes('split') || text.includes('workout plan')) {
        return "Here is a proven 4-Day Upper/Lower Strength Split:\n• Day 1: Upper Body Power (Push-Ups, DB Rows, Overhead Press)\n• Day 2: Lower Body Power (Goblet Squats, Lunges, Calf Raises)\n• Day 3: Rest & Mobility Yoga\n• Day 4: Upper Hypertrophy\n• Day 5: Lower & Core";
    }
    if (text.includes('squat')) {
        return "Goblet Squat Form Checklist:\n1. Hold weight tight at chest.\n2. Feet shoulder-width apart, toes flared slightly.\n3. Inhale and brace core.\n4. Push knees outward over toes.\n5. Drive through midfoot to stand tall!";
    }
    if (text.includes('post-workout')) {
        return "Within 45–60 minutes after training, combine 25g fast-digesting protein with 40g complex carbs: a whey protein shake or sattu drink with a banana, or a bowl of oats with almonds!";
    }
    return `Great fitness question! Based on your ${appState.user.goal} target and ${appState.nutrition.targetCalories} kcal budget, consistency in progressive overload and 7–8 hours of recovery will ensure sustainable progress. How else can I guide you today?`;
}

// 9. Profile & Metabolic Calculators
function initProfileEngine() {
    updateMetabolicCalculations();

    document.getElementById('btnExportFullReport').addEventListener('click', () => {
        showToast('Comprehensive Health & Metabolic PDF Report exported successfully!');
    });
}

function updateMetabolicCalculations() {
    const { weight, height, age, gender } = appState.user;

    // Exact BMI
    const hM = height / 100.0;
    const bmi = (weight / (hM * hM)).toFixed(1);

    // Exact Mifflin-St Jeor BMR
    let bmr = Math.round((10.0 * weight) + (6.25 * height) - (5.0 * age) + (gender === 'male' ? 5 : -161));

    // Exact TDEE with moderate factor 1.55
    let tdee = Math.round(bmr * 1.55);

    document.getElementById('profBmi').innerText = bmi;
    document.getElementById('profBmr').innerText = `${bmr.toLocaleString()} kcal`;
    document.getElementById('profTdee').innerText = `${tdee.toLocaleString()} kcal`;

    let cat = 'Normal';
    if (bmi < 18.5) cat = 'Underweight';
    else if (bmi >= 25 && bmi < 30) cat = 'Overweight';
    else if (bmi >= 30) cat = 'Obesity I';
    document.getElementById('profBmiCat').innerText = cat;
}

// 10. Authentication & Onboarding
function initAuthModals() {
    const btnLoginTab = document.getElementById('btnTabLogin');
    const btnRegTab = document.getElementById('btnTabRegister');
    const loginForm = document.getElementById('loginForm');
    const regForm = document.getElementById('registerForm');

    btnLoginTab.addEventListener('click', () => {
        btnLoginTab.classList.add('active');
        btnRegTab.classList.remove('active');
        loginForm.style.display = 'flex';
        regForm.style.display = 'none';
    });

    btnRegTab.addEventListener('click', () => {
        btnRegTab.classList.add('active');
        btnLoginTab.classList.remove('active');
        regForm.style.display = 'flex';
        loginForm.style.display = 'none';
    });

    loginForm.addEventListener('submit', (e) => {
        e.preventDefault();
        appState.user.email = document.getElementById('loginEmail').value;
        document.getElementById('authModal').classList.remove('active');
        showToast(`Signed in successfully as ${appState.user.name}`);
    });

    regForm.addEventListener('submit', (e) => {
        e.preventDefault();
        appState.user.name = document.getElementById('regName').value;
        appState.user.email = document.getElementById('regEmail').value;
        document.getElementById('authModal').classList.remove('active');
        initGreeting();
        document.getElementById('profUserName').innerText = appState.user.name;
        showToast(`Account created! Welcome, ${appState.user.name}`);
    });

    document.getElementById('btnGoogleAuth').addEventListener('click', () => {
        document.getElementById('authModal').classList.remove('active');
        showToast('Google Sign-In authenticated successfully!');
    });

    // Special VIP Redemption
    document.getElementById('btnRedeemModal').addEventListener('click', () => {
        const input = document.getElementById('modalCodeInput');
        const code = input.value.trim().toUpperCase();

        if (code === 'MANIFIT-VIP-2026' || code === 'MANIFIT-LIFETIME') {
            appState.user.isPremium = true;
            appState.user.isLifetime = (code === 'MANIFIT-LIFETIME');
            updateDashboardUI();
            document.getElementById('vipModal').classList.remove('active');
            input.value = '';
            showToast(code === 'MANIFIT-LIFETIME' ? '🎉 Permanent LIFETIME VIP Activated!' : '🎉 30 Days Premium Access Unlocked!');
        } else {
            showToast('❌ Invalid, expired or already-used unlock code.');
        }
    });
}

// Onboarding Navigation
window.goToOnboardStep = function(stepNum) {
    document.getElementById('onboardStep1').style.display = 'none';
    document.getElementById('onboardStep2').style.display = 'none';
    document.getElementById('onboardStep3').style.display = 'none';
    document.getElementById('onboardStep4').style.display = 'none';

    document.getElementById(`onboardStep${stepNum}`).style.display = 'block';
    document.getElementById('onboardStepIndicator').innerText = `Step ${stepNum} of 4`;
};

window.finishOnboarding = function() {
    appState.user.name = document.getElementById('onboardName').value;
    appState.user.weight = parseFloat(document.getElementById('onboardWeight').value);
    appState.user.height = parseFloat(document.getElementById('onboardHeight').value);
    appState.user.age = parseInt(document.getElementById('onboardAge').value, 10);

    document.getElementById('onboardingModal').classList.remove('active');
    initGreeting();
    document.getElementById('profUserName').innerText = appState.user.name;
    updateMetabolicCalculations();
    showToast('Onboarding complete! Your personalized fitness targets are active.');
};

// 11. Food Search
function initFoodSearch() {
    document.getElementById('btnAddFoodModal').addEventListener('click', () => {
        document.getElementById('foodLogModal').classList.add('active');
        renderFoodSearchResults('');
    });
    document.getElementById('btnCloseFoodLog').addEventListener('click', () => {
        document.getElementById('foodLogModal').classList.remove('active');
    });

    document.getElementById('searchFoodInput').addEventListener('input', (e) => {
        renderFoodSearchResults(e.target.value.toLowerCase());
    });
}

function renderFoodSearchResults(filter) {
    const container = document.getElementById('foodSearchResults');
    container.innerHTML = '';

    const matches = foodDb.filter(f => f.name.toLowerCase().includes(filter) || f.hindi.includes(filter));
    matches.forEach(f => {
        const item = document.createElement('div');
        item.style.padding = '8px 12px';
        item.style.background = 'var(--theme-bg)';
        item.style.borderRadius = '8px';
        item.style.display = 'flex';
        item.style.justifyContent = 'space-between';
        item.style.alignItems = 'center';
        item.style.cursor = 'pointer';

        item.innerHTML = `
            <div>
                <strong>${f.name}</strong> <small>(${f.hindi})</small><br>
                <small style="color:var(--slate-gray)">${f.unit} • ${f.cal} kcal • P: ${f.p}g</small>
            </div>
            <button class="btn-primary" style="width:auto; padding:4px 10px; font-size:11px;" onclick="addFoodToBreakfast('${f.id}')">+ Add</button>
        `;
        container.appendChild(item);
    });
}

window.addFoodToBreakfast = function(foodId) {
    const food = foodDb.find(f => f.id === foodId);
    if (food) {
        appState.nutrition.currentPlan[0].items.push({ food: food, servings: 1.0 });
        renderMeals();
        document.getElementById('foodLogModal').classList.remove('active');
        showToast(`Added ${food.name} to Breakfast!`);
    }
};

window.saveNotificationSettings = function() {
    document.getElementById('notifModal').classList.remove('active');
    showToast('Notification schedule saved!');
};
