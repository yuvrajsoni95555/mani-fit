// MANI FIT Mobile Web Application & Interactive Engine

// State
let appState = {
    user: {
        name: 'Yuvraj Soni',
        age: 26,
        weight: 72.0,
        height: 175.0,
        gender: 'male',
        activity: 'moderate',
        goal: 'loss',
        isPremium: false,
        isLifetime: false,
        validUntil: null
    },
    nutrition: {
        targetCalories: 1950,
        dietaryPattern: 'vegetarian',
        currentPlan: null
    },
    hydration: {
        consumedMl: 1750,
        targetMl: 2500
    },
    workout: {
        activeTimer: null,
        activeSeconds: 0,
        activeTitle: '',
        level: 'beginner'
    }
};

// Curated authentic food database referencing ICMR-NIN IFCT & USDA FDC
const foodDb = [
    { id: 'roti', name: 'Whole Wheat Roti', hindi: 'रोटी', unit: '1 roti (35g)', grams: 35, cal: 104, p: 3.7, c: 21.4, f: 0.5, type: 'vegan' },
    { id: 'oats', name: 'Rolled Oats (Cooked)', hindi: 'ओट्स', unit: '1 bowl (200g)', grams: 200, cal: 142, p: 5.0, c: 24.0, f: 3.0, type: 'vegan' },
    { id: 'dal', name: 'Yellow Moong Dal Tadka', hindi: 'दाल तड़का', unit: '1 bowl (150g)', grams: 150, cal: 156, p: 10.2, c: 23.2, f: 3.3, type: 'vegan' },
    { id: 'paneer', name: 'Low Fat Paneer', hindi: 'पनीर', unit: '1 portion (100g)', grams: 100, cal: 180, p: 18.0, c: 3.5, f: 10.5, type: 'vegetarian' },
    { id: 'soya', name: 'Soya Chunks Curry', hindi: 'सोया चंक्स', unit: '1 bowl (150g)', grams: 150, cal: 165, p: 22.8, c: 12.7, f: 1.8, type: 'vegan' },
    { id: 'chicken', name: 'Grilled Chicken Breast', hindi: 'ग्रिल्ड चिकन', unit: '1 fillet (150g)', grams: 150, cal: 247, p: 46.5, c: 0.0, f: 5.4, type: 'nonVegetarian' },
    { id: 'egg', name: 'Whole Boiled Egg', hindi: 'उबला अंडा', unit: '1 egg (50g)', grams: 50, cal: 78, p: 6.3, c: 0.6, f: 5.3, type: 'eggetarian' },
    { id: 'dahi', name: 'Fresh Plain Curd / Dahi', hindi: 'दही', unit: '1 cup (150g)', grams: 150, cal: 92, p: 5.2, c: 7.0, f: 5.0, type: 'vegetarian' },
    { id: 'sprouts', name: 'Moong Sprout Salad', hindi: 'अंकुरित सलाद', unit: '1 bowl (120g)', grams: 120, cal: 98, p: 7.4, c: 16.2, f: 1.0, type: 'vegan' },
    { id: 'almonds', name: 'Raw Almonds', hindi: 'बादाम', unit: '10 almonds (12g)', grams: 12, cal: 70, p: 2.5, c: 2.6, f: 6.0, type: 'vegan' },
    { id: 'apple', name: 'Fresh Apple with Skin', hindi: 'सेब', unit: '1 medium (150g)', grams: 150, cal: 78, p: 0.5, c: 20.7, f: 0.3, type: 'vegan' }
];

// Workout Library
const workoutLibrary = [
    {
        id: 'home_base',
        title: 'Home Foundation Resiliency',
        desc: 'Zero equipment bodyweight circuit for joint stability and core strength.',
        duration: '25 min',
        level: 'beginner',
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
        duration: '40 min',
        level: 'intermediate',
        exercises: [
            'Goblet Squats: 4 sets × 12 reps (75s rest)',
            'Bent-Over DB Rows: 4 sets × 12 reps (75s rest)',
            'Overhead Shoulder Press: 3 sets × 10 reps (60s rest)',
            'Core Plank: 3 sets × 60 sec (45s rest)'
        ]
    },
    {
        id: 'power_strength',
        title: 'Heavy Barbell & High Intensity',
        desc: 'Compound power movements for advanced strength athletes.',
        duration: '50 min',
        level: 'advanced',
        exercises: [
            'Deadlifts: 4 sets × 6 reps (120s rest)',
            'Barbell Bench Press: 4 sets × 8 reps (90s rest)',
            'Pull-Ups / Weighted Dips: 3 sets to failure',
            'HIIT Sprints: 6 intervals × 30s'
        ]
    }
];

// DOM Ready
document.addEventListener('DOMContentLoaded', () => {
    initNavigation();
    initDietChartEngine();
    initWorkoutEngine();
    initAiCoach();
    initProfileEngine();
    initVipModal();
    updateDashboardUI();
});

function showToast(msg) {
    const toast = document.getElementById('appToast');
    toast.innerText = msg;
    toast.style.display = 'block';
    setTimeout(() => {
        toast.style.display = 'none';
    }, 2800);
}

// Navigation
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

    // Quick Dashboard Action cards
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

    document.getElementById('btnOpenOrganizer').addEventListener('click', () => {
        showToast('Health Organizer: 2 Active Medications, 1 Confirmed Appointment.');
    });
}

// Hydration
window.addWater = function(ml) {
    appState.hydration.consumedMl = Math.min(5000, appState.hydration.consumedMl + ml);
    updateDashboardUI();
    showToast(`Logged +${ml}ml of water! Total: ${appState.hydration.consumedMl} ml`);
};

// Dashboard Updates
function updateDashboardUI() {
    const { consumedMl, targetMl } = appState.hydration;
    document.getElementById('waterStats').innerText = `${consumedMl} / ${targetMl} ml`;
    const pct = Math.min(100, Math.round((consumedMl / targetMl) * 100));
    document.getElementById('waterBar').style.width = `${pct}%`;

    // VIP Pill
    const pill = document.getElementById('vipPill');
    if (appState.user.isPremium) {
        pill.innerText = appState.user.isLifetime ? 'VIP LIFETIME' : 'PREMIUM ACTIVE';
        pill.className = 'vip-status-pill gold';
    } else {
        pill.innerText = 'FREE PLAN';
        pill.className = 'vip-status-pill';
    }
}

// Diet Chart Engine
function initDietChartEngine() {
    const slider = document.getElementById('dietCalSlider');
    const display = document.getElementById('dietCalDisplay');
    const chips = document.querySelectorAll('#dietaryChips .chip');

    slider.addEventListener('input', (e) => {
        appState.nutrition.targetCalories = parseInt(e.target.value, 10);
        display.innerText = `${appState.nutrition.targetCalories} kcal`;
        generateMealPlan();
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
    const target = appState.nutrition.targetCalories;

    // Filter compliant foods
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
            title: 'Lean Recovery Dinner (08:30 PM)',
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
                        <small style="color:var(--slate-grey)">${itemCal} kcal • P: ${itemP}g, C: ${itemC}g, F: ${itemF}g</small>
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

    // Update Banner
    document.getElementById('totCal').innerText = Math.round(totalCal);
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
        li.innerHTML = `<strong>${food}</strong> <span>${qty}</span>`;
        listUl.appendChild(li);
    });

    document.getElementById('groceryModal').classList.add('active');
}

function exportDietPlan() {
    showToast('Diet Chart Markdown export copied to clipboard!');
}

// Workout Engine
function initWorkoutEngine() {
    const chips = document.querySelectorAll('#workoutLevelChips .chip');
    chips.forEach(chip => {
        chip.addEventListener('click', () => {
            chips.forEach(c => c.classList.remove('active'));
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

    const filtered = workoutLibrary.filter(r => r.level === appState.workout.level);
    filtered.forEach(r => {
        const card = document.createElement('div');
        card.className = 'routine-card';
        card.innerHTML = `
            <h3>${r.title}</h3>
            <p>${r.desc}</p>
            <small style="color:var(--primary-burgundy); font-weight:600;">⏱️ Duration: ${r.duration}</small>
            <ul style="margin: 10px 0 10px 18px; font-size:12px; color:var(--charcoal);">
                ${r.exercises.map(e => `<li>${e}</li>`).join('')}
            </ul>
            <button class="btn-start-routine" onclick="startRoutine('${r.title}')">Start Routine</button>
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
    showToast(`Great job! Routine completed in ${Math.floor(s/60)}m ${s%60}s. Burned ~${Math.round(s*0.12)} kcal!`);
}

// AI Coach Engine
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

    // User Message
    const userMsg = document.createElement('div');
    userMsg.className = 'chat-msg user';
    userMsg.innerHTML = `<p>${query}</p>`;
    viewport.appendChild(userMsg);
    viewport.scrollTop = viewport.scrollHeight;

    // Simulated Gemini response with context and safety rules
    setTimeout(() => {
        const coachMsg = document.createElement('div');
        coachMsg.className = 'chat-msg coach';
        coachMsg.innerHTML = `<p>${generateCoachResponse(query)}</p><small>⚠️ Not medical advice</small>`;
        viewport.appendChild(coachMsg);
        viewport.scrollTop = viewport.scrollHeight;
    }, 400);
};

function generateCoachResponse(q) {
    const text = q.toLowerCase();
    if (text.includes('protein')) {
        return "With your 72kg weight and fitness goal, aim for 120–140g of protein daily. Focus on paneer, lentils, soya chunks, Greek yogurt, or whey isolate distributed across your 4 scheduled meals!";
    }
    if (text.includes('pre-workout') || text.includes('before workout')) {
        return "For sustained energy without gastrointestinal discomfort, eat complex carbohydrates 60–90 minutes prior: rolled oats with banana or a slice of whole wheat toast with a light protein source.";
    }
    if (text.includes('deficit') || text.includes('loss')) {
        return "A moderate 300–500 kcal deficit preserves metabolic rate and lean muscle tissue while losing body fat at a healthy rate of ~0.5kg/week. Avoid crash dieting below safe physiological thresholds.";
    }
    return "Great question! Staying consistent with your 1,950 kcal target, prioritizing 7–8 hours of quality sleep, and progressively overloading your training will deliver lasting results. What specific aspect should we dial in?";
}

// Profile Engine
function initProfileEngine() {
    const slW = document.getElementById('slWeight');
    const slH = document.getElementById('slHeight');
    const slA = document.getElementById('slAge');

    const updateMetrics = () => {
        const w = parseFloat(slW.value);
        const h = parseFloat(slH.value);
        const a = parseInt(slA.value, 10);

        document.getElementById('lblWeight').innerText = `${w.toFixed(1)} kg`;
        document.getElementById('lblHeight').innerText = `${h} cm`;
        document.getElementById('lblAge').innerText = `${a} yrs`;

        // Mifflin-St Jeor formula
        const bmi = (w / ((h / 100) * (h / 100))).toFixed(1);
        const bmr = Math.round((10 * w) + (6.25 * h) - (5 * a) + 5);
        const tdee = Math.round(bmr * 1.55); // Moderate activity
        const targetCal = tdee - 500; // Deficit

        document.getElementById('profBmi').innerText = bmi;
        document.getElementById('profBmr').innerText = `${bmr} kcal`;
        document.getElementById('profTdee').innerText = `${tdee} kcal`;
        document.getElementById('profTargetCal').innerText = `${targetCal} kcal`;

        let cat = 'Normal Weight';
        if (bmi < 18.5) cat = 'Underweight';
        else if (bmi >= 25 && bmi < 30) cat = 'Overweight';
        else if (bmi >= 30) cat = 'Obese Class I';
        document.getElementById('profBmiCat').innerText = cat;
    };

    slW.addEventListener('input', updateMetrics);
    slH.addEventListener('input', updateMetrics);
    slA.addEventListener('input', updateMetrics);
}

// VIP Redemption
function initVipModal() {
    document.getElementById('btnRedeemModal').addEventListener('click', () => {
        const input = document.getElementById('modalCodeInput');
        const code = input.value.trim().toUpperCase();

        if (code === 'MANIFIT-VIP-2026' || code === 'MANIFIT-LIFETIME') {
            appState.user.isPremium = true;
            appState.user.isLifetime = (code === 'MANIFIT-LIFETIME');
            updateDashboardUI();
            document.getElementById('vipModal').classList.remove('active');
            input.value = '';
            showToast(code === 'MANIFIT-LIFETIME' ? '🎉 Permanent LIFETIME VIP Unlocked!' : '🎉 30 Days Premium Access Unlocked!');
        } else {
            showToast('❌ Invalid or expired unlock code.');
        }
    });
}
