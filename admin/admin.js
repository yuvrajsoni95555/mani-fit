// MANI FIT Administration Dashboard Controller

// State Collections
let adminState = {
    users: [
        {
            uid: 'usr_84920',
            name: 'Aarav Mehta',
            email: 'aarav.mehta@example.com',
            age: 28,
            weight: 76.5,
            height: 178,
            goal: 'Muscle Gain',
            subscription: 'premium',
            validUntil: '2026-11-28',
            isLifetime: false
        },
        {
            uid: 'usr_39201',
            name: 'Pooja Iyer',
            email: 'pooja.iyer@example.com',
            age: 24,
            weight: 58.0,
            height: 162,
            goal: 'Weight Loss',
            subscription: 'free',
            validUntil: null,
            isLifetime: false
        },
        {
            uid: 'usr_19482',
            name: 'Vikram Rajput',
            email: 'vikram.r@example.com',
            age: 32,
            weight: 84.0,
            height: 181,
            goal: 'Maintenance',
            subscription: 'premium',
            validUntil: 'Permanent',
            isLifetime: true
        }
    ],
    codes: [
        {
            code: 'MANIFIT-VIP-2026',
            entitlement: 'monthly_30d',
            maxRedemptions: 50,
            currentRedemptions: 18,
            expiresAt: '2026-12-31',
            isActive: true,
            notes: 'Official VIP beta launch pass'
        },
        {
            code: 'MANIFIT-LIFETIME',
            entitlement: 'lifetime',
            maxRedemptions: 5,
            currentRedemptions: 2,
            expiresAt: '2027-01-01',
            isActive: true,
            notes: 'Founding Member Access'
        },
        {
            code: 'MANIFIT-PARTNER-90',
            entitlement: 'quarterly_90d',
            maxRedemptions: 20,
            currentRedemptions: 7,
            expiresAt: '2026-11-30',
            isActive: true,
            notes: 'Corporate Wellness Alliance'
        }
    ],
    payments: [
        {
            txId: 'TXN_UPI_983271029',
            uid: 'usr_84920',
            amount: '₹100',
            channel: 'UPI (yuvrajsoni95555-1@okaxis)',
            date: '2026-10-28 14:22',
            status: 'CONFIRMED'
        },
        {
            txId: 'TXN_PLAY_482019481',
            uid: 'usr_44910',
            amount: '₹100',
            channel: 'Google Play Billing',
            date: '2026-10-27 18:10',
            status: 'CONFIRMED'
        }
    ],
    foods: [
        { name: 'Whole Wheat Roti', cat: 'Grains & Cereals', type: 'Vegan', serving: '1 roti (35g)', cal: '297 / 10.5g / 61.2g / 1.5g', prov: 'ICMR-NIN IFCT 2017' },
        { name: 'Moong Dal Tadka', cat: 'Pulses & Legumes', type: 'Vegan', serving: '1 bowl (150g)', cal: '104 / 6.8g / 15.5g / 2.2g', prov: 'ICMR-NIN IFCT 2017' },
        { name: 'Fresh Paneer (Low Fat)', cat: 'Dairy & Alternatives', type: 'Vegetarian', serving: '1 portion (100g)', cal: '180 / 18.0g / 3.5g / 10.5g', prov: 'ICMR-NIN IFCT 2017' },
        { name: 'Grilled Chicken Breast', cat: 'Meat & Poultry', type: 'Non-Veg', serving: '1 fillet (150g)', cal: '165 / 31.0g / 0.0g / 3.6g', prov: 'USDA FDC' },
        { name: 'Soya Chunks Curry', cat: 'Pulses & Legumes', type: 'Vegan', serving: '1 bowl (150g)', cal: '110 / 15.2g / 8.5g / 1.2g', prov: 'ICMR-NIN IFCT 2017' }
    ],
    auditLogs: [
        { time: '2026-10-28 18:30:11', actor: 'Yuvraj Soni (Admin)', action: 'RULES_DEPLOY', target: 'firestore.rules', details: 'Harden Validator functions and RBAC' },
        { time: '2026-10-28 17:15:00', actor: 'System (Cloud Functions)', action: 'ATOMIC_CODE_REDEEM', target: 'usr_84920', details: 'Redeemed MANIFIT-VIP-2026' }
    ]
};

// UI Initialization
document.addEventListener('DOMContentLoaded', () => {
    setupNavigation();
    renderAll();
    setupForm();
    setupSearch();
});

function showToast(message) {
    const container = document.getElementById('toastContainer');
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.innerText = message;
    container.appendChild(toast);
    setTimeout(() => {
        toast.remove();
    }, 3500);
}

function setupNavigation() {
    const navItems = document.querySelectorAll('.nav-item');
    const panes = document.querySelectorAll('.tab-pane');
    const title = document.getElementById('pageTitle');

    navItems.forEach(btn => {
        btn.addEventListener('click', () => {
            const target = btn.getAttribute('data-tab');
            navItems.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            panes.forEach(p => p.classList.remove('active'));
            document.getElementById(`tab-${target}`).classList.add('active');

            // Update title
            const titles = {
                overview: 'Overview & Analytics',
                users: 'User Accounts & Biometrics',
                codes: 'Special VIP & Promo Codes',
                payments: 'Payment & Entitlement Gateways',
                content: 'Curated Food & Content Engine',
                audit: 'Administrative Security Audit'
            };
            title.innerText = titles[target] || 'Administration';
        });
    });

    document.getElementById('btnQuickCreateCode').addEventListener('click', () => {
        document.querySelector('[data-tab="codes"]').click();
        document.getElementById('inputCode').focus();
    });

    document.getElementById('btnLogout').addEventListener('click', () => {
        showToast('Signed out of administrative session.');
    });

    document.getElementById('btnExportAudit').addEventListener('click', () => {
        const rows = [
            ['Timestamp', 'Actor', 'Action', 'Target', 'Details'],
            ...adminState.auditLogs.map(l => [l.time, l.actor, l.action, l.target, l.details])
        ];
        const csvContent = 'data:text/csv;charset=utf-8,' + rows.map(e => e.join(',')).join('\n');
        const encodedUri = encodeURI(csvContent);
        const link = document.createElement('a');
        link.setAttribute('href', encodedUri);
        link.setAttribute('download', `MANI_FIT_AUDIT_${Date.now()}.csv`);
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        showToast('Audit log CSV exported successfully.');
    });
}

function renderAll() {
    renderUsers();
    renderCodes();
    renderPayments();
    renderFoods();
    renderAudit();
    document.getElementById('statActiveCodes').innerText = adminState.codes.filter(c => c.isActive).length;
}

function renderUsers(filterText = '') {
    const tbody = document.querySelector('#usersTable tbody');
    tbody.innerHTML = '';

    const filtered = adminState.users.filter(u => 
        u.name.toLowerCase().includes(filterText.toLowerCase()) ||
        u.email.toLowerCase().includes(filterText.toLowerCase()) ||
        u.uid.toLowerCase().includes(filterText.toLowerCase())
    );

    filtered.forEach(u => {
        const tr = document.createElement('tr');
        const isPrem = u.subscription === 'premium';

        tr.innerHTML = `
            <td>
                <strong>${u.name}</strong><br>
                <small style="color:var(--slate-grey)">${u.email} • ${u.uid}</small>
            </td>
            <td>${u.weight} kg • ${u.height} cm • Age ${u.age}</td>
            <td><span class="badge badge-info">${u.goal}</span></td>
            <td>
                <span class="badge ${isPrem ? 'badge-success' : 'badge-warning'}">
                    ${isPrem ? (u.isLifetime ? 'VIP LIFETIME' : 'PREMIUM') : 'FREE'}
                </span>
            </td>
            <td>${u.validUntil || '—'}</td>
            <td>
                <button class="btn-secondary" onclick="toggleUserSubscription('${u.uid}')">
                    ${isPrem ? 'Revoke VIP' : 'Grant Premium'}
                </button>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

window.toggleUserSubscription = function(uid) {
    const user = adminState.users.find(u => u.uid === uid);
    if (!user) return;

    if (user.subscription === 'premium') {
        user.subscription = 'free';
        user.validUntil = null;
        user.isLifetime = false;
        adminState.auditLogs.unshift({
            time: new Date().toISOString().replace('T', ' ').substring(0, 19),
            actor: 'Yuvraj Soni (Admin)',
            action: 'REVOKE_ENTITLEMENT',
            target: uid,
            details: 'Subscription downgraded to Free'
        });
        showToast(`Revoked Premium entitlement for ${user.name}`);
    } else {
        user.subscription = 'premium';
        user.validUntil = '2026-11-28';
        user.isLifetime = false;
        adminState.auditLogs.unshift({
            time: new Date().toISOString().replace('T', ' ').substring(0, 19),
            actor: 'Yuvraj Soni (Admin)',
            action: 'MANUAL_GRANT_ENTITLEMENT',
            target: uid,
            details: 'Granted 30-day Premium access'
        });
        showToast(`Granted 30-day Premium for ${user.name}`);
    }
    renderUsers();
    renderAudit();
};

function renderCodes() {
    const tbody = document.querySelector('#codesTable tbody');
    tbody.innerHTML = '';

    adminState.codes.forEach(c => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td><strong style="font-family:monospace; font-size:14px; color:var(--primary-burgundy);">${c.code}</strong></td>
            <td><span class="badge badge-info">${c.entitlement.replace('_', ' ').toUpperCase()}</span></td>
            <td><strong>${c.currentRedemptions}</strong> / ${c.maxRedemptions}</td>
            <td>${c.expiresAt}</td>
            <td>
                <span class="badge ${c.isActive ? 'badge-success' : 'badge-danger'}">
                    ${c.isActive ? 'ACTIVE' : 'DEACTIVATED'}
                </span>
            </td>
            <td><small>${c.notes || '—'}</small></td>
            <td>
                ${c.isActive 
                    ? `<button class="btn-danger" onclick="revokeCode('${c.code}')">Revoke</button>`
                    : `<span style="color:var(--slate-grey); font-size:11px;">Disabled</span>`
                }
            </td>
        `;
        tbody.appendChild(tr);
    });
}

window.revokeCode = function(codeStr) {
    const codeObj = adminState.codes.find(c => c.code === codeStr);
    if (!codeObj) return;

    codeObj.isActive = false;
    adminState.auditLogs.unshift({
        time: new Date().toISOString().replace('T', ' ').substring(0, 19),
        actor: 'Yuvraj Soni (Admin)',
        action: 'CODE_REVOCATION',
        target: codeStr,
        details: 'Code deactivated by admin'
    });
    showToast(`Code ${codeStr} has been deactivated.`);
    renderCodes();
    renderAudit();
    document.getElementById('statActiveCodes').innerText = adminState.codes.filter(c => c.isActive).length;
};

function setupForm() {
    const form = document.getElementById('createCodeForm');
    // Set default date to 3 months from now
    const d = new Date();
    d.setMonth(d.getMonth() + 3);
    document.getElementById('inputExpiry').value = d.toISOString().split('T')[0];

    form.addEventListener('submit', (e) => {
        e.preventDefault();
        const code = document.getElementById('inputCode').value.trim().toUpperCase();
        const entitlement = document.getElementById('selectEntitlement').value;
        const maxRedemptions = parseInt(document.getElementById('inputMaxRedemptions').value, 10);
        const expiresAt = document.getElementById('inputExpiry').value;
        const notes = document.getElementById('inputNotes').value.trim();

        if (adminState.codes.some(c => c.code === code)) {
            alert('A code with this identifier already exists.');
            return;
        }

        adminState.codes.unshift({
            code,
            entitlement,
            maxRedemptions,
            currentRedemptions: 0,
            expiresAt,
            isActive: true,
            notes
        });

        adminState.auditLogs.unshift({
            time: new Date().toISOString().replace('T', ' ').substring(0, 19),
            actor: 'Yuvraj Soni (Admin)',
            action: 'CREATE_SPECIAL_CODE',
            target: code,
            details: `Created entitlement: ${entitlement}, max uses: ${maxRedemptions}`
        });

        showToast(`Created special unlock code: ${code}`);
        form.reset();
        document.getElementById('inputExpiry').value = d.toISOString().split('T')[0];
        renderCodes();
        renderAudit();
        document.getElementById('statActiveCodes').innerText = adminState.codes.filter(c => c.isActive).length;
    });
}

function renderPayments() {
    const tbody = document.querySelector('#paymentsTable tbody');
    tbody.innerHTML = '';

    adminState.payments.forEach(p => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td><strong style="font-family:monospace;">${p.txId}</strong></td>
            <td>${p.uid}</td>
            <td><strong>${p.amount}</strong></td>
            <td><small>${p.channel}</small></td>
            <td>${p.date}</td>
            <td><span class="badge badge-success">${p.status}</span></td>
        `;
        tbody.appendChild(tr);
    });
}

function renderFoods() {
    const tbody = document.querySelector('#foodsTable tbody');
    tbody.innerHTML = '';

    adminState.foods.forEach(f => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td><strong>${f.name}</strong></td>
            <td>${f.cat}</td>
            <td><span class="badge badge-info">${f.type}</span></td>
            <td>${f.serving}</td>
            <td><code style="color:var(--primary-burgundy);">${f.cal}</code></td>
            <td><small style="color:var(--slate-grey);">${f.prov}</small></td>
        `;
        tbody.appendChild(tr);
    });
}

function renderAudit() {
    const tbody = document.querySelector('#auditTable tbody');
    tbody.innerHTML = '';

    adminState.auditLogs.forEach(l => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td><small style="color:var(--slate-grey);">${l.time}</small></td>
            <td><strong>${l.actor}</strong></td>
            <td><span class="badge badge-warning">${l.action}</span></td>
            <td><code>${l.target}</code></td>
            <td>${l.details}</td>
        `;
        tbody.appendChild(tr);
    });
}

function setupSearch() {
    const input = document.getElementById('userSearch');
    input.addEventListener('input', (e) => {
        renderUsers(e.target.value);
    });
}
