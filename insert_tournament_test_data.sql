-- Test data for tournaments table
-- Run this in your Supabase SQL editor

-- First, let's insert some test clubs if they don't exist
INSERT INTO clubs (id, name, description, address, total_tournaments, total_members, rating, created_at) VALUES
  ('550e8400-e29b-41d4-a716-446655440001', 'CLB Bida A', 'Câu lạc bộ billiards chuyên nghiệp tại TP.HCM', 'Quận 1, TP.HCM', 5, 50, 4.5, NOW()),
  ('550e8400-e29b-41d4-a716-446655440002', 'CLB Bida B', 'Câu lạc bộ billiards hiện đại tại Hà Nội', 'Quận Ba Đình, Hà Nội', 3, 30, 4.2, NOW()),
  ('550e8400-e29b-41d4-a716-446655440003', 'CLB Bida C', 'Câu lạc bộ billiards cao cấp tại Đà Nẵng', 'Quận Hải Châu, Đà Nẵng', 8, 80, 4.8, NOW()),
  ('550e8400-e29b-41d4-a716-446655440004', 'CLB Bida D', 'Câu lạc bộ billiards thân thiện tại Cần Thơ', 'Quận Ninh Kiều, Cần Thơ', 2, 20, 4.0, NOW())
ON CONFLICT (id) DO NOTHING;

-- Now insert test tournaments
INSERT INTO tournaments (
  id, 
  club_id, 
  title, 
  description, 
  format, 
  entry_fee, 
  prize_pool, 
  max_participants, 
  current_participants, 
  start_date, 
  end_date, 
  registration_deadline, 
  status, 
  cover_image_url, 
  has_live_stream, 
  skill_level, 
  created_at
) VALUES
  (
    '660e8400-e29b-41d4-a716-446655440001',
    '550e8400-e29b-41d4-a716-446655440001',
    'Giải đấu Mùa Xuân 2025',
    'Giải đấu billiards 8-ball chuyên nghiệp dành cho các tay cơ giỏi',
    '8-Ball',
    50000,
    1000000,
    32,
    12,
    NOW() + INTERVAL '7 days',
    NOW() + INTERVAL '14 days',
    NOW() + INTERVAL '5 days',
    'upcoming',
    'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=200&fit=crop',
    true,
    'intermediate',
    NOW()
  ),
  (
    '660e8400-e29b-41d4-a716-446655440002',
    '550e8400-e29b-41d4-a716-446655440002',
    'Giải đấu Mùa Hè 2025',
    'Giải đấu billiards 9-ball miễn phí cho tất cả mọi người',
    '9-Ball',
    0,
    500000,
    64,
    20,
    NOW() + INTERVAL '14 days',
    NOW() + INTERVAL '21 days',
    NOW() + INTERVAL '10 days',
    'upcoming',
    'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400&h=200&fit=crop',
    false,
    'beginner',
    NOW()
  ),
  (
    '660e8400-e29b-41d4-a716-446655440003',
    '550e8400-e29b-41d4-a716-446655440003',
    'Giải đấu Đang Diễn Ra',
    'Giải đấu 10-ball cao cấp với livestream và giải thưởng lớn',
    '10-Ball',
    100000,
    2000000,
    32,
    32,
    NOW() - INTERVAL '1 day',
    NOW() + INTERVAL '6 days',
    NOW() - INTERVAL '3 days',
    'live',
    'https://images.unsplash.com/photo-1579952363873-27d3bfad9c0d?w=400&h=200&fit=crop',
    true,
    'professional',
    NOW() - INTERVAL '1 day'
  ),
  (
    '660e8400-e29b-41d4-a716-446655440004',
    '550e8400-e29b-41d4-a716-446655440004',
    'Giải đấu Đã Kết Thúc',
    'Giải đấu 8-ball vừa kết thúc với nhiều trận đấu hấp dẫn',
    '8-Ball',
    20000,
    300000,
    16,
    16,
    NOW() - INTERVAL '10 days',
    NOW() - INTERVAL '3 days',
    NOW() - INTERVAL '12 days',
    'completed',
    'https://images.unsplash.com/photo-1574680096145-d05b474e2155?w=400&h=200&fit=crop',
    false,
    'intermediate',
    NOW() - INTERVAL '10 days'
  ),
  (
    '660e8400-e29b-41d4-a716-446655440005',
    '550e8400-e29b-41d4-a716-446655440001',
    'Giải Vô Địch Quốc Gia',
    'Giải đấu billiards vô địch quốc gia với sự tham gia của các cao thủ',
    '9-Ball',
    200000,
    5000000,
    16,
    8,
    NOW() + INTERVAL '30 days',
    NOW() + INTERVAL '37 days',
    NOW() + INTERVAL '25 days',
    'upcoming',
    'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400&h=200&fit=crop',
    true,
    'professional',
    NOW()
  ),
  (
    '660e8400-e29b-41d4-a716-446655440006',
    '550e8400-e29b-41d4-a716-446655440002',
    'Giải Billiards Phong Trào',
    'Giải đấu thân thiện dành cho người mới bắt đầu',
    '8-Ball',
    30000,
    200000,
    24,
    15,
    NOW() + INTERVAL '21 days',
    NOW() + INTERVAL '23 days',
    NOW() + INTERVAL '18 days',
    'upcoming',
    'https://images.unsplash.com/photo-1551058233-96e14f8bb96e?w=400&h=200&fit=crop',
    false,
    'beginner',
    NOW()
  )
ON CONFLICT (id) DO NOTHING;

-- Update club tournament counts
UPDATE clubs SET total_tournaments = (
  SELECT COUNT(*) FROM tournaments WHERE club_id = clubs.id
);

-- Create some test participants if user table exists
-- This is optional and only if you have users in your database
INSERT INTO tournament_participants (tournament_id, user_id, registration_date, payment_status) 
SELECT 
  '660e8400-e29b-41d4-a716-446655440001',
  u.id,
  NOW() - INTERVAL '2 days',
  'paid'
FROM users u 
LIMIT 12
ON CONFLICT (tournament_id, user_id) DO NOTHING;

-- Enable RLS (Row Level Security) if not already enabled
ALTER TABLE tournaments ENABLE ROW LEVEL SECURITY;
ALTER TABLE clubs ENABLE ROW LEVEL SECURITY;

-- Create policies to allow public read access for testing
-- You may want to modify these based on your security requirements
DROP POLICY IF EXISTS "Public read access for tournaments" ON tournaments;
CREATE POLICY "Public read access for tournaments" ON tournaments
  FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public read access for clubs" ON clubs;
CREATE POLICY "Public read access for clubs" ON clubs
  FOR SELECT USING (true);