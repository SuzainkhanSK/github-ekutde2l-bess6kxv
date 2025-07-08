/*
  # Fix Leaderboard Query Function

  1. New Functions
    - `get_top_users` - Returns top users by points for the leaderboard
    - Handles null points values properly
    - Returns users sorted by points in descending order

  2. Security
    - Function uses SECURITY DEFINER to access data with elevated privileges
    - Available to both authenticated and anonymous users
*/

-- Create function to get top users for leaderboard
CREATE OR REPLACE FUNCTION public.get_top_users(limit_param integer DEFAULT 10)
RETURNS SETOF profiles
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT 
    id, 
    email, 
    full_name, 
    COALESCE(points, 0) as points, 
    profile_image, 
    created_at,
    updated_at,
    phone,
    total_earned,
    referral_code,
    referred_by
  FROM profiles
  ORDER BY COALESCE(points, 0) DESC
  LIMIT limit_param;
$$;

-- Grant execute permission to authenticated and anonymous users
GRANT EXECUTE ON FUNCTION public.get_top_users(integer) TO authenticated, anon;