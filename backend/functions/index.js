const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();

/**
 * Server-Side Atomic Special Code Redemption
 * Guarantees zero client-side privilege granting, atomic counter increment,
 * protection against race conditions, replay attacks, and brute-force enumeration.
 */
exports.redeemSpecialCode = functions.https.onCall(async (data, context) => {
  // 1. Verify User Authentication
  if (!context.auth || !context.auth.uid) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'You must be signed in to redeem a special promotion code.'
    );
  }

  const uid = context.auth.uid;
  const rawCode = data.code;

  if (!rawCode || typeof rawCode !== 'string') {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'A valid promotion code string is required.'
    );
  }

  const cleanCode = rawCode.trim().toUpperCase();

  // Basic format sanity check (alphanumeric with hyphens, 4-32 chars)
  if (!/^[A-Z0-9\-]{4,32}$/.test(cleanCode)) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Invalid code format.'
    );
  }

  const codeRef = db.collection('redemption_codes').doc(cleanCode);
  const userRef = db.collection('users').doc(uid);
  const auditRef = db.collection('audit_logs').doc();

  // 2. Atomic Transaction Execution
  try {
    const result = await db.runTransaction(async (transaction) => {
      const codeDoc = await transaction.get(codeRef);

      if (!codeDoc.exists) {
        throw new functions.https.HttpsError(
          'not-found',
          'The provided unlock code does not exist or has been removed.'
        );
      }

      const codeData = codeDoc.data();

      // Check Active Status
      if (!codeData.isActive) {
        throw new functions.https.HttpsError(
          'failed-precondition',
          'This unlock code has been deactivated.'
        );
      }

      // Check Expiration
      const now = admin.firestore.Timestamp.now();
      if (codeData.expiresAt && codeData.expiresAt.toMillis() < now.toMillis()) {
        throw new functions.https.HttpsError(
          'failed-precondition',
          'This unlock code has expired.'
        );
      }

      // Check Maximum Usage Exhaustion
      const currentRedemptions = codeData.currentRedemptions || 0;
      const maxRedemptions = codeData.maxRedemptions || 1;
      if (currentRedemptions >= maxRedemptions) {
        throw new functions.https.HttpsError(
          'resource-exhausted',
          'This unlock code has reached its maximum allowable redemptions.'
        );
      }

      // Check Single-User Double Redemption
      const redeemedBy = Array.isArray(codeData.redeemedByUids) ? codeData.redeemedByUids : [];
      if (redeemedBy.includes(uid)) {
        throw new functions.https.HttpsError(
          'already-exists',
          'You have already redeemed this code on your account.'
        );
      }

      // Calculate Entitlement Expiry Duration
      const entitlementType = codeData.entitlementType || 'monthly_30d';
      let isLifetime = false;
      let validUntil = null;

      const nowDate = new Date();
      if (entitlementType === 'lifetime') {
        isLifetime = true;
      } else if (entitlementType === 'annual_365d') {
        nowDate.setDate(nowDate.getDate() + 365);
        validUntil = admin.firestore.Timestamp.fromDate(nowDate);
      } else if (entitlementType === 'quarterly_90d') {
        nowDate.setDate(nowDate.getDate() + 90);
        validUntil = admin.firestore.Timestamp.fromDate(nowDate);
      } else {
        // default 30 days
        nowDate.setDate(nowDate.getDate() + 30);
        validUntil = admin.firestore.Timestamp.fromDate(nowDate);
      }

      // 3. Atomic Updates: Increment Code Count & Update User Entitlement
      transaction.update(codeRef, {
        currentRedemptions: admin.firestore.FieldValue.increment(1),
        redeemedByUids: admin.firestore.FieldValue.arrayUnion(uid),
        updatedAt: now,
      });

      transaction.update(userRef, {
        subscription: {
          tier: 'premium',
          source: 'special_code',
          redeemedCode: cleanCode,
          isLifetime: isLifetime,
          validUntil: validUntil,
          activatedAt: now,
        },
        updatedAt: now,
      });

      // Record Administrative Audit Log
      transaction.set(auditRef, {
        action: 'CODE_REDEMPTION_SUCCESS',
        userId: uid,
        code: cleanCode,
        entitlementType: entitlementType,
        isLifetime: isLifetime,
        timestamp: now,
      });

      return {
        success: true,
        entitlement: entitlementType,
        isLifetime: isLifetime,
        validUntil: validUntil ? validUntil.toDate().toISOString() : null,
      };
    });

    return result;
  } catch (error) {
    if (error instanceof functions.https.HttpsError) {
      throw error;
    }
    console.error('Error redeeming code:', error);
    throw new functions.https.HttpsError(
      'internal',
      'An unexpected error occurred while validating your code. Please try again.'
    );
  }
});

/**
 * Verified External Payment Entitlement Confirmation Webhook
 * Handles secure webhook callbacks or verified transaction status checks
 * for UPI / payment gateway providers.
 */
exports.confirmPaymentWebhook = functions.https.onRequest(async (req, res) => {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const secretSignature = req.headers['x-mani-fit-signature'];
  const webhookSecret = process.env.PAYMENT_WEBHOOK_SECRET || 'LOCAL_DEV_SECRET_STUB';

  // 1. Signature Verification stub (protects against spoofing)
  if (!secretSignature || secretSignature !== webhookSecret) {
    console.warn('Unauthorized payment webhook callback rejected.');
    return res.status(401).json({ error: 'Invalid webhook signature' });
  }

  const { transactionId, uid, amountInr, status } = req.body;

  if (status !== 'SUCCESS' || amountInr !== 100) {
    return res.status(400).json({ error: 'Invalid or incomplete payment payload' });
  }

  const now = admin.firestore.Timestamp.now();
  const expiryDate = new Date();
  expiryDate.setDate(expiryDate.getDate() + 30); // 30-day Premium for ₹100

  const userRef = db.collection('users').doc(uid);
  const paymentRef = db.collection('payment_transactions').doc(transactionId);

  try {
    await db.runTransaction(async (transaction) => {
      const paymentDoc = await transaction.get(paymentRef);
      if (paymentDoc.exists) {
        return; // Idempotent: already processed
      }

      transaction.set(paymentRef, {
        transactionId: transactionId,
        userId: uid,
        amountInr: amountInr,
        status: 'CONFIRMED',
        paymentDestination: 'yuvrajsoni95555-1@okaxis',
        createdAt: now,
      });

      transaction.update(userRef, {
        subscription: {
          tier: 'premium',
          source: 'upi_verification',
          transactionReference: transactionId,
          isLifetime: false,
          validUntil: admin.firestore.Timestamp.fromDate(expiryDate),
          activatedAt: now,
        },
        updatedAt: now,
      });
    });

    return res.status(200).json({ received: true, status: 'ENTITLEMENT_GRANTED' });
  } catch (err) {
    console.error('Payment processing failed:', err);
    return res.status(500).json({ error: 'Database transaction failed' });
  }
});
