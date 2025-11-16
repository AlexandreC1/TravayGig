-- =====================================================
-- TravayGig Supabase Database Schema
-- =====================================================
-- This schema creates all necessary tables, RLS policies,
-- triggers, and functions for the TravayGig marketplace.
-- =====================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis"; -- For future geospatial queries

-- =====================================================
-- PROFILES TABLE
-- =====================================================
-- Stores user profile information synced with auth.users

CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    avatar_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

-- Add indexes for performance
CREATE INDEX IF NOT EXISTS profiles_email_idx ON public.profiles(email);

-- Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- RLS Policies for profiles
-- Anyone can view profiles (for displaying gig creators)
CREATE POLICY "Profiles are viewable by everyone"
    ON public.profiles
    FOR SELECT
    USING (true);

-- Users can insert their own profile
CREATE POLICY "Users can insert their own profile"
    ON public.profiles
    FOR INSERT
    WITH CHECK (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update their own profile"
    ON public.profiles
    FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- =====================================================
-- GIGS TABLE
-- =====================================================
-- Stores gig/job postings

CREATE TABLE IF NOT EXISTS public.gigs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    location_name TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT title_length CHECK (char_length(title) >= 3 AND char_length(title) <= 100),
    CONSTRAINT description_length CHECK (char_length(description) >= 10 AND char_length(description) <= 1000),
    CONSTRAINT valid_coordinates CHECK (
        latitude >= -90 AND latitude <= 90 AND
        longitude >= -180 AND longitude <= 180
    )
);

-- Add indexes for performance
CREATE INDEX IF NOT EXISTS gigs_user_id_idx ON public.gigs(user_id);
CREATE INDEX IF NOT EXISTS gigs_created_at_idx ON public.gigs(created_at DESC);
CREATE INDEX IF NOT EXISTS gigs_price_idx ON public.gigs(price);

-- Create a geography column for spatial queries (future enhancement)
-- ALTER TABLE public.gigs ADD COLUMN IF NOT EXISTS location geography(POINT, 4326);
-- UPDATE public.gigs SET location = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326);
-- CREATE INDEX IF NOT EXISTS gigs_location_idx ON public.gigs USING GIST(location);

-- Enable Row Level Security
ALTER TABLE public.gigs ENABLE ROW LEVEL SECURITY;

-- RLS Policies for gigs
-- Everyone can view all gigs
CREATE POLICY "Gigs are viewable by everyone"
    ON public.gigs
    FOR SELECT
    USING (true);

-- Authenticated users can create gigs
CREATE POLICY "Authenticated users can create gigs"
    ON public.gigs
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Users can update their own gigs
CREATE POLICY "Users can update their own gigs"
    ON public.gigs
    FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Users can delete their own gigs
CREATE POLICY "Users can delete their own gigs"
    ON public.gigs
    FOR DELETE
    USING (auth.uid() = user_id);

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Trigger to automatically create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name, created_at)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', 'User'),
        NOW()
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to profiles
DROP TRIGGER IF EXISTS profiles_updated_at ON public.profiles;
CREATE TRIGGER profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- Apply to gigs
DROP TRIGGER IF EXISTS gigs_updated_at ON public.gigs;
CREATE TRIGGER gigs_updated_at
    BEFORE UPDATE ON public.gigs
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- =====================================================
-- STORAGE BUCKETS (for avatars and gig images)
-- =====================================================

-- Create storage buckets
INSERT INTO storage.buckets (id, name, public)
VALUES
    ('avatars', 'avatars', true),
    ('gig_images', 'gig_images', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies for avatars
CREATE POLICY "Avatar images are publicly accessible"
    ON storage.objects FOR SELECT
    USING (bucket_id = 'avatars');

CREATE POLICY "Users can upload their own avatar"
    ON storage.objects FOR INSERT
    WITH CHECK (
        bucket_id = 'avatars' AND
        auth.uid()::text = (storage.foldername(name))[1]
    );

CREATE POLICY "Users can update their own avatar"
    ON storage.objects FOR UPDATE
    USING (
        bucket_id = 'avatars' AND
        auth.uid()::text = (storage.foldername(name))[1]
    );

-- Storage policies for gig images
CREATE POLICY "Gig images are publicly accessible"
    ON storage.objects FOR SELECT
    USING (bucket_id = 'gig_images');

CREATE POLICY "Authenticated users can upload gig images"
    ON storage.objects FOR INSERT
    WITH CHECK (
        bucket_id = 'gig_images' AND
        auth.role() = 'authenticated'
    );

-- =====================================================
-- HELPER FUNCTIONS
-- =====================================================

-- Function to search gigs by text
CREATE OR REPLACE FUNCTION public.search_gigs(search_query TEXT)
RETURNS SETOF public.gigs AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM public.gigs
    WHERE
        title ILIKE '%' || search_query || '%' OR
        description ILIKE '%' || search_query || '%'
    ORDER BY created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- Function to get nearby gigs (simplified version without PostGIS)
-- Note: This is a simplified distance calculation and not accurate for long distances
CREATE OR REPLACE FUNCTION public.get_nearby_gigs(
    user_lat DOUBLE PRECISION,
    user_lon DOUBLE PRECISION,
    radius_km DOUBLE PRECISION DEFAULT 10
)
RETURNS TABLE (
    id UUID,
    user_id UUID,
    title TEXT,
    description TEXT,
    price NUMERIC,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    location_name TEXT,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    distance_km DOUBLE PRECISION
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        g.*,
        (
            6371 * acos(
                cos(radians(user_lat)) *
                cos(radians(g.latitude)) *
                cos(radians(g.longitude) - radians(user_lon)) +
                sin(radians(user_lat)) *
                sin(radians(g.latitude))
            )
        ) as distance_km
    FROM public.gigs g
    WHERE (
        6371 * acos(
            cos(radians(user_lat)) *
            cos(radians(g.latitude)) *
            cos(radians(g.longitude) - radians(user_lon)) +
            sin(radians(user_lat)) *
            sin(radians(g.latitude))
        )
    ) <= radius_km
    ORDER BY distance_km ASC;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- SAMPLE DATA (for development/testing)
-- =====================================================
-- Uncomment the following to insert sample data

/*
-- Insert sample profiles (make sure to create auth users first)
INSERT INTO public.profiles (id, email, full_name) VALUES
    ('00000000-0000-0000-0000-000000000001', 'jean@example.com', 'Jean Baptiste'),
    ('00000000-0000-0000-0000-000000000002', 'marie@example.com', 'Marie Joseph')
ON CONFLICT (id) DO NOTHING;

-- Insert sample gigs
INSERT INTO public.gigs (user_id, title, description, price, latitude, longitude, location_name) VALUES
    (
        '00000000-0000-0000-0000-000000000001',
        'Konstriksyon Kay',
        'Mwen bezwen yon mason pou konstriksyon yon ti kay nan katye a',
        50000,
        18.5944,
        -72.3074,
        'Port-au-Prince, Ayiti'
    ),
    (
        '00000000-0000-0000-0000-000000000002',
        'Netwayman',
        'Sèvis netwayman pou kay ak biwo',
        5000,
        18.5944,
        -72.3074,
        'Delmas, Port-au-Prince'
    )
ON CONFLICT DO NOTHING;
*/

-- =====================================================
-- GRANTS
-- =====================================================
-- Grant necessary permissions

GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO anon, authenticated;

-- =====================================================
-- SCHEMA COMPLETE
-- =====================================================
