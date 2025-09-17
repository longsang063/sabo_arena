-- Simple test data script for Club Dashboard
-- This script works with existing database structure without changes

-- Insert test data directly into existing tables
-- Check if we have existing clubs first
SELECT id, name FROM clubs LIMIT 5;

-- If we have clubs, let's create some mock revenue and activity data
-- Since ClubDashboardService uses mock data anyway, we just need clubs to exist

-- Create some sample matches to generate activities
INSERT INTO matches (
  id, 
  tournament_id, 
  player1_id, 
  player2_id, 
  winner_id,
  player1_score,
  player2_score,
  status,
  scheduled_at,
  completed_at,
  created_at
) VALUES 
  (
    gen_random_uuid(),
    NULL, -- casual match
    (SELECT id FROM auth.users LIMIT 1), 
    (SELECT id FROM auth.users OFFSET 1 LIMIT 1),
    (SELECT id FROM auth.users LIMIT 1),
    8,
    6,
    'completed',
    NOW() - INTERVAL '2 hours',
    NOW() - INTERVAL '1 hour', 
    NOW() - INTERVAL '2 hours'
  ),
  (
    gen_random_uuid(),
    NULL,
    (SELECT id FROM auth.users OFFSET 1 LIMIT 1),
    (SELECT id FROM auth.users OFFSET 2 LIMIT 1), 
    (SELECT id FROM auth.users OFFSET 1 LIMIT 1),
    8,
    4,
    'completed',
    NOW() - INTERVAL '1 day',
    NOW() - INTERVAL '23 hours',
    NOW() - INTERVAL '1 day'
  ),
  (
    gen_random_uuid(),
    NULL,
    (SELECT id FROM auth.users OFFSET 2 LIMIT 1),
    (SELECT id FROM auth.users LIMIT 1),
    (SELECT id FROM auth.users OFFSET 2 LIMIT 1), 
    8,
    7,
    'completed',
    NOW() - INTERVAL '3 days',
    NOW() - INTERVAL '3 days' + INTERVAL '1 hour',
    NOW() - INTERVAL '3 days'
  )
ON CONFLICT (id) DO NOTHING;

-- Create some tournaments for activity
INSERT INTO tournaments (
  id,
  title,
  description,
  organizer_id,
  club_id,
  start_date,
  end_date,
  registration_deadline,
  max_participants,
  entry_fee,
  prize_pool,
  status,
  tournament_type,
  game_format,
  created_at
) VALUES 
  (
    gen_random_uuid(),
    'Weekly Club Championship',
    'Giải đấu hàng tuần của club',
    (SELECT id FROM auth.users LIMIT 1),
    (SELECT id FROM clubs LIMIT 1),
    NOW() + INTERVAL '1 week',
    NOW() + INTERVAL '2 weeks', 
    NOW() + INTERVAL '5 days',
    16,
    50000,
    500000,
    'open',
    'single_elimination',
    '8-ball',
    NOW() - INTERVAL '2 days'
  ),
  (
    gen_random_uuid(),
    'Monthly Tournament',
    'Giải đấu hàng tháng',
    (SELECT id FROM auth.users OFFSET 1 LIMIT 1),
    (SELECT id FROM clubs LIMIT 1),
    NOW() - INTERVAL '1 week',
    NOW() - INTERVAL '3 days',
    NOW() - INTERVAL '10 days', 
    8,
    100000,
    800000,
    'completed',
    'round_robin',
    '9-ball',
    NOW() - INTERVAL '2 weeks'
  )
ON CONFLICT (id) DO NOTHING;

-- Verify we have data
SELECT 
  'clubs' as table_name,
  COUNT(*) as count
FROM clubs
UNION ALL
SELECT 
  'matches' as table_name,
  COUNT(*) as count  
FROM matches
UNION ALL
SELECT
  'tournaments' as table_name,
  COUNT(*) as count
FROM tournaments;

-- Show club info for verification
SELECT 
  id,
  name,
  total_members,
  total_tournaments,
  created_at
FROM clubs 
LIMIT 3;