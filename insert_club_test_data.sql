-- Test data for clubs and club memberships
-- Run this in your Supabase SQL editor

-- First, ensure we have users (create some test users if not exist)
INSERT INTO users (id, email, username, full_name, bio, avatar_url, created_at) VALUES
  ('550e8400-e29b-41d4-a716-446655441001', 'user1@test.com', 'user1', 'Nguyễn Văn A', 'Người chơi billiards chuyên nghiệp', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop', NOW()),
  ('550e8400-e29b-41d4-a716-446655441002', 'user2@test.com', 'user2', 'Trần Thị B', 'Đam mê billiards từ nhỏ', 'https://images.unsplash.com/photo-1494790108755-2616b60e23b4?w=100&h=100&fit=crop', NOW()),
  ('550e8400-e29b-41d4-a716-446655441003', 'user3@test.com', 'user3', 'Lê Văn C', 'Cao thủ billiards miền Nam', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop', NOW()),
  ('550e8400-e29b-41d4-a716-446655441004', 'user4@test.com', 'user4', 'Phạm Thị D', 'Huấn luyện viên billiards', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop', NOW()),
  ('550e8400-e29b-41d4-a716-446655441005', 'user5@test.com', 'user5', 'Hoàng Văn E', 'Chủ club billiards Sài Gòn', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop', NOW())
ON CONFLICT (id) DO NOTHING;

-- Update existing clubs with more realistic data  
UPDATE clubs SET 
  total_members = CASE 
    WHEN id = '550e8400-e29b-41d4-a716-446655440001' THEN 25
    WHEN id = '550e8400-e29b-41d4-a716-446655440002' THEN 18
    WHEN id = '550e8400-e29b-41d4-a716-446655440003' THEN 42
    WHEN id = '550e8400-e29b-41d4-a716-446655440004' THEN 12
    ELSE total_members
  END,
  total_tournaments = CASE 
    WHEN id = '550e8400-e29b-41d4-a716-446655440001' THEN 8
    WHEN id = '550e8400-e29b-41d4-a716-446655440002' THEN 5
    WHEN id = '550e8400-e29b-41d4-a716-446655440003' THEN 15
    WHEN id = '550e8400-e29b-41d4-a716-446655440004' THEN 3
    ELSE total_tournaments
  END,
  rating = CASE 
    WHEN id = '550e8400-e29b-41d4-a716-446655440001' THEN 4.5
    WHEN id = '550e8400-e29b-41d4-a716-446655440002' THEN 4.2
    WHEN id = '550e8400-e29b-41d4-a716-446655440003' THEN 4.8
    WHEN id = '550e8400-e29b-41d4-a716-446655440004' THEN 4.0
    ELSE rating
  END,
  owner_id = CASE
    WHEN id = '550e8400-e29b-41d4-a716-446655440001' THEN '550e8400-e29b-41d4-a716-446655441005'
    WHEN id = '550e8400-e29b-41d4-a716-446655440002' THEN '550e8400-e29b-41d4-a716-446655441001'
    WHEN id = '550e8400-e29b-41d4-a716-446655440003' THEN '550e8400-e29b-41d4-a716-446655441002'
    WHEN id = '550e8400-e29b-41d4-a716-446655440004' THEN '550e8400-e29b-41d4-a716-446655441003'
    ELSE owner_id
  END;

-- Create club_memberships table if not exists
CREATE TABLE IF NOT EXISTS club_memberships (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  club_id UUID REFERENCES clubs(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  role VARCHAR(20) DEFAULT 'member', -- member, admin, owner
  status VARCHAR(20) DEFAULT 'pending', -- pending, approved, rejected
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(club_id, user_id)
);

-- Insert club memberships
INSERT INTO club_memberships (club_id, user_id, role, status, joined_at, created_at) VALUES
  -- CLB Bida A members
  ('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655441005', 'owner', 'approved', NOW() - INTERVAL '90 days', NOW() - INTERVAL '90 days'),
  ('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655441001', 'admin', 'approved', NOW() - INTERVAL '60 days', NOW() - INTERVAL '60 days'), 
  ('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655441002', 'member', 'approved', NOW() - INTERVAL '30 days', NOW() - INTERVAL '30 days'),
  ('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655441003', 'member', 'approved', NOW() - INTERVAL '15 days', NOW() - INTERVAL '15 days'),
  ('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655441004', 'member', 'approved', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),
  
  -- CLB Bida B members
  ('550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655441001', 'owner', 'approved', NOW() - INTERVAL '120 days', NOW() - INTERVAL '120 days'),
  ('550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655441002', 'member', 'approved', NOW() - INTERVAL '40 days', NOW() - INTERVAL '40 days'),
  ('550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655441003', 'member', 'approved', NOW() - INTERVAL '20 days', NOW() - INTERVAL '20 days'),
  
  -- CLB Bida C members  
  ('550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655441002', 'owner', 'approved', NOW() - INTERVAL '200 days', NOW() - INTERVAL '200 days'),
  ('550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655441003', 'admin', 'approved', NOW() - INTERVAL '100 days', NOW() - INTERVAL '100 days'),
  ('550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655441004', 'member', 'approved', NOW() - INTERVAL '50 days', NOW() - INTERVAL '50 days'),
  ('550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655441005', 'member', 'approved', NOW() - INTERVAL '25 days', NOW() - INTERVAL '25 days'),
  
  -- CLB Bida D members
  ('550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655441003', 'owner', 'approved', NOW() - INTERVAL '80 days', NOW() - INTERVAL '80 days'),
  ('550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655441004', 'member', 'approved', NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days')
ON CONFLICT (club_id, user_id) DO NOTHING;

-- Update users last_seen to simulate active users
UPDATE users SET 
  last_seen = CASE 
    WHEN id = '550e8400-e29b-41d4-a716-446655441001' THEN NOW() - INTERVAL '2 hours'
    WHEN id = '550e8400-e29b-41d4-a716-446655441002' THEN NOW() - INTERVAL '1 day'
    WHEN id = '550e8400-e29b-41d4-a716-446655441003' THEN NOW() - INTERVAL '3 days'
    WHEN id = '550e8400-e29b-41d4-a716-446655441004' THEN NOW() - INTERVAL '1 week'
    WHEN id = '550e8400-e29b-41d4-a716-446655441005' THEN NOW() - INTERVAL '45 days'
    ELSE last_seen
  END,
  is_online = CASE 
    WHEN id IN ('550e8400-e29b-41d4-a716-446655441001', '550e8400-e29b-41d4-a716-446655441002') THEN true
    ELSE false
  END;

-- Enable RLS for club_memberships
ALTER TABLE club_memberships ENABLE ROW LEVEL SECURITY;

-- Create policy for club_memberships
DROP POLICY IF EXISTS "Public read access for club_memberships" ON club_memberships;
CREATE POLICY "Public read access for club_memberships" ON club_memberships
  FOR SELECT USING (true);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_club_memberships_club_id ON club_memberships(club_id);
CREATE INDEX IF NOT EXISTS idx_club_memberships_user_id ON club_memberships(user_id);
CREATE INDEX IF NOT EXISTS idx_club_memberships_status ON club_memberships(status);
CREATE INDEX IF NOT EXISTS idx_users_last_seen ON users(last_seen);

-- Test query to verify data
SELECT 
  c.name as club_name,
  c.total_members,
  c.total_tournaments,
  COUNT(cm.id) as actual_members,
  COUNT(CASE WHEN u.last_seen > NOW() - INTERVAL '30 days' THEN 1 END) as active_members
FROM clubs c
LEFT JOIN club_memberships cm ON c.id = cm.club_id AND cm.status = 'approved'
LEFT JOIN users u ON cm.user_id = u.id
WHERE c.id IN (
  '550e8400-e29b-41d4-a716-446655440001',
  '550e8400-e29b-41d4-a716-446655440002', 
  '550e8400-e29b-41d4-a716-446655440003',
  '550e8400-e29b-41d4-a716-446655440004'
)
GROUP BY c.id, c.name, c.total_members, c.total_tournaments
ORDER BY c.name;