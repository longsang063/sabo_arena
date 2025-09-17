-- Migration: Convert from user_profiles to users table
-- This will rename user_profiles to users and update all foreign key references

-- Step 1: Rename user_profiles table to users
ALTER TABLE user_profiles RENAME TO users;

-- Step 2: Update all foreign key constraints to reference users instead of user_profiles
-- Clubs table
ALTER TABLE clubs DROP CONSTRAINT IF EXISTS clubs_owner_id_fkey;
ALTER TABLE clubs ADD CONSTRAINT clubs_owner_id_fkey 
  FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE;

-- Club memberships table  
ALTER TABLE club_memberships DROP CONSTRAINT IF EXISTS club_memberships_user_id_fkey;
ALTER TABLE club_memberships ADD CONSTRAINT club_memberships_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- Tournaments table
ALTER TABLE tournaments DROP CONSTRAINT IF EXISTS tournaments_organizer_id_fkey;
ALTER TABLE tournaments ADD CONSTRAINT tournaments_organizer_id_fkey
  FOREIGN KEY (organizer_id) REFERENCES users(id) ON DELETE CASCADE;

-- Tournament participants table
ALTER TABLE tournament_participants DROP CONSTRAINT IF EXISTS tournament_participants_user_id_fkey;
ALTER TABLE tournament_participants ADD CONSTRAINT tournament_participants_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- Matches table
ALTER TABLE matches DROP CONSTRAINT IF EXISTS matches_player1_id_fkey;
ALTER TABLE matches DROP CONSTRAINT IF EXISTS matches_player2_id_fkey;
ALTER TABLE matches DROP CONSTRAINT IF EXISTS matches_winner_id_fkey;
ALTER TABLE matches ADD CONSTRAINT matches_player1_id_fkey
  FOREIGN KEY (player1_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE matches ADD CONSTRAINT matches_player2_id_fkey
  FOREIGN KEY (player2_id) REFERENCES users(id);
ALTER TABLE matches ADD CONSTRAINT matches_winner_id_fkey
  FOREIGN KEY (winner_id) REFERENCES users(id);

-- Posts table
ALTER TABLE posts DROP CONSTRAINT IF EXISTS posts_user_id_fkey;
ALTER TABLE posts ADD CONSTRAINT posts_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- Comments table
ALTER TABLE comments DROP CONSTRAINT IF EXISTS comments_user_id_fkey;
ALTER TABLE comments ADD CONSTRAINT comments_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- Post likes table
ALTER TABLE post_likes DROP CONSTRAINT IF EXISTS post_likes_user_id_fkey;
ALTER TABLE post_likes ADD CONSTRAINT post_likes_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- Follows table (if exists)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'follows') THEN
    ALTER TABLE follows DROP CONSTRAINT IF EXISTS follows_follower_id_fkey;
    ALTER TABLE follows DROP CONSTRAINT IF EXISTS follows_following_id_fkey;
    ALTER TABLE follows ADD CONSTRAINT follows_follower_id_fkey
      FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE;
    ALTER TABLE follows ADD CONSTRAINT follows_following_id_fkey
      FOREIGN KEY (following_id) REFERENCES users(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Notifications table (if exists)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'notifications') THEN
    ALTER TABLE notifications DROP CONSTRAINT IF EXISTS notifications_user_id_fkey;
    ALTER TABLE notifications ADD CONSTRAINT notifications_user_id_fkey
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Messages table (if exists)  
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'messages') THEN
    ALTER TABLE messages DROP CONSTRAINT IF EXISTS messages_user_id_fkey;
    ALTER TABLE messages ADD CONSTRAINT messages_user_id_fkey
      FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
  END IF;
END $$;

-- Step 3: Update indexes
DROP INDEX IF EXISTS idx_user_profiles_username;
DROP INDEX IF EXISTS idx_user_profiles_role;
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Step 4: Update RLS policies
-- Drop old policies
DROP POLICY IF EXISTS "public_can_read_user_profiles" ON users;
DROP POLICY IF EXISTS "users_manage_own_user_profiles" ON users;

-- Create new policies for users table
CREATE POLICY "Public read access for users" ON users
  FOR SELECT USING (true);

CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Step 5: Update any views that reference user_profiles
-- This is a catch-all for any views that might exist
DO $$
DECLARE
    view_record RECORD;
BEGIN
    FOR view_record IN 
        SELECT viewname FROM pg_views 
        WHERE schemaname = 'public' 
        AND definition LIKE '%user_profiles%'
    LOOP
        EXECUTE 'DROP VIEW IF EXISTS ' || view_record.viewname || ' CASCADE';
    END LOOP;
END $$;

-- Step 6: Verify the change worked
SELECT 
  table_name,
  column_name,
  constraint_name,
  foreign_table_name,
  foreign_column_name
FROM information_schema.key_column_usage k
JOIN information_schema.referential_constraints r ON k.constraint_name = r.constraint_name
JOIN information_schema.constraint_column_usage u ON r.unique_constraint_name = u.constraint_name
WHERE u.table_name = 'users'
ORDER BY table_name, column_name;

-- Success message
SELECT 'Migration completed: user_profiles table renamed to users and all foreign keys updated' as status;