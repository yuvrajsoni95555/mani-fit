-- ====================================================================
-- MANI FIT — Production Supabase / PostgreSQL Schema & RLS Policies
-- ====================================================================

-- 1. Create Enums
CREATE TYPE user_role AS ENUM ('user', 'admin');
CREATE TYPE subscription_tier AS ENUM ('free', 'premium');
CREATE TYPE subscription_source AS ENUM ('none', 'google_play', 'upi_verification', 'special_code');
CREATE TYPE entitlement_type AS ENUM ('monthly_30d', 'quarterly_90d', 'annual_365d', 'lifetime');
CREATE TYPE dietary_pattern AS ENUM ('vegetarian', 'vegan', 'eggetarian', 'non_vegetarian', 'jain');
CREATE TYPE fitness_goal AS ENUM ('weight_loss', 'maintenance', 'muscle_gain');

-- 2. Profiles Table
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    display_name TEXT,
    role user_role DEFAULT 'user' NOT NULL,
    age INT CHECK (age >= 1 AND age <= 120),
    height_cm NUMERIC(5, 2) CHECK (height_cm >= 50 AND height_cm <= 260),
    weight_kg NUMERIC(5, 2) CHECK (weight_kg >= 20 AND weight_kg <= 400),
    gender TEXT,
    activity_level TEXT,
    goal fitness_goal DEFAULT 'weight_loss',
    dietary_pattern dietary_pattern DEFAULT 'vegetarian',
    allergies TEXT[] DEFAULT '{}',
    target_weight_kg NUMERIC(5, 2),
    -- Subscription status
    subscription_tier subscription_tier DEFAULT 'free' NOT NULL,
    subscription_source subscription_source DEFAULT 'none' NOT NULL,
    subscription_valid_until TIMESTAMPTZ,
    is_lifetime BOOLEAN DEFAULT FALSE NOT NULL,
    redeemed_code TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Enable RLS on Profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own profile"
    ON public.profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile non-privileged fields"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (
        auth.uid() = id AND
        role = (SELECT role FROM public.profiles WHERE id = auth.uid()) AND
        subscription_tier = (SELECT subscription_tier FROM public.profiles WHERE id = auth.uid())
    );

-- 3. Diet Charts Table
CREATE TABLE IF NOT EXISTS public.diet_charts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    target_calories NUMERIC(6, 2) NOT NULL,
    dietary_pattern dietary_pattern NOT NULL,
    excluded_allergens TEXT[] DEFAULT '{}',
    meals_json JSONB NOT NULL,
    daily_nutrients JSONB NOT NULL,
    is_customized BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

ALTER TABLE public.diet_charts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own diet charts"
    ON public.diet_charts FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- 4. Food Logs Table
CREATE TABLE IF NOT EXISTS public.food_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    meal_type TEXT NOT NULL,
    food_name TEXT NOT NULL,
    grams NUMERIC(6, 2) NOT NULL,
    calories NUMERIC(6, 2) NOT NULL,
    protein_g NUMERIC(5, 2) NOT NULL,
    carbs_g NUMERIC(5, 2) NOT NULL,
    fat_g NUMERIC(5, 2) NOT NULL,
    fiber_g NUMERIC(5, 2) DEFAULT 0.0,
    is_ai_estimated BOOLEAN DEFAULT FALSE,
    logged_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

ALTER TABLE public.food_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own food logs"
    ON public.food_logs FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- 5. Water Logs Table
CREATE TABLE IF NOT EXISTS public.water_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    amount_ml INT NOT NULL CHECK (amount_ml > 0),
    logged_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

ALTER TABLE public.water_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own water logs"
    ON public.water_logs FOR ALL
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- 6. Special Redemption Codes (Restricted Table)
CREATE TABLE IF NOT EXISTS public.redemption_codes (
    code TEXT PRIMARY KEY,
    entitlement entitlement_type NOT NULL,
    max_redemptions INT DEFAULT 1 NOT NULL,
    current_redemptions INT DEFAULT 0 NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    redeemed_by_uids UUID[] DEFAULT '{}',
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

ALTER TABLE public.redemption_codes ENABLE ROW LEVEL SECURITY;

-- Notice: Standard users have NO direct SELECT/INSERT/UPDATE permissions on redemption_codes.
-- Only server functions (SECURITY DEFINER) or admins can interact with this table.
CREATE POLICY "Admins full access on redemption codes"
    ON public.redemption_codes FOR ALL
    USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin'));

-- 7. Audit Logs Table
CREATE TABLE IF NOT EXISTS public.audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    action TEXT NOT NULL,
    user_id UUID,
    details JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can view audit logs"
    ON public.audit_logs FOR SELECT
    USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin'));

-- 8. Stored Procedure for Atomic Code Redemption
CREATE OR REPLACE FUNCTION public.redeem_code(p_code TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_uid UUID := auth.uid();
    v_code RECORD;
    v_entitlement entitlement_type;
    v_is_lifetime BOOLEAN := FALSE;
    v_valid_until TIMESTAMPTZ;
BEGIN
    IF v_uid IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    -- Lock row for update
    SELECT * INTO v_code
    FROM public.redemption_codes
    WHERE code = UPPER(TRIM(p_code))
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Invalid unlock code';
    END IF;

    IF NOT v_code.is_active THEN
        RAISE EXCEPTION 'Code has been deactivated';
    END IF;

    IF NOW() > v_code.expires_at THEN
        RAISE EXCEPTION 'Code has expired';
    END IF;

    IF v_code.current_redemptions >= v_code.max_redemptions THEN
        RAISE EXCEPTION 'Code redemptions exhausted';
    END IF;

    IF v_uid = ANY(v_code.redeemed_by_uids) THEN
        RAISE EXCEPTION 'Code already redeemed by this account';
    END IF;

    -- Compute duration
    v_entitlement := v_code.entitlement;
    IF v_entitlement = 'lifetime' THEN
        v_is_lifetime := TRUE;
        v_valid_until := NULL;
    ELSIF v_entitlement = 'annual_365d' THEN
        v_valid_until := NOW() + INTERVAL '365 days';
    ELSIF v_entitlement = 'quarterly_90d' THEN
        v_valid_until := NOW() + INTERVAL '90 days';
    ELSE
        v_valid_until := NOW() + INTERVAL '30 days';
    END IF;

    -- Update Code
    UPDATE public.redemption_codes
    SET current_redemptions = current_redemptions + 1,
        redeemed_by_uids = array_append(redeemed_by_uids, v_uid)
    WHERE code = v_code.code;

    -- Update User Profile
    UPDATE public.profiles
    SET subscription_tier = 'premium',
        subscription_source = 'special_code',
        redeemed_code = v_code.code,
        is_lifetime = v_is_lifetime,
        subscription_valid_until = v_valid_until,
        updated_at = NOW()
    WHERE id = v_uid;

    -- Record Audit Log
    INSERT INTO public.audit_logs (action, user_id, details)
    VALUES ('CODE_REDEEMED', v_uid, jsonb_build_object('code', v_code.code, 'entitlement', v_entitlement));

    RETURN jsonb_build_object(
        'success', true,
        'entitlement', v_entitlement,
        'is_lifetime', v_is_lifetime,
        'valid_until', v_valid_until
    );
END;
$$;
