-- SQL Functions for Tournament Repository
-- Add these to your Supabase SQL editor

-- Function to increment tournament participants
CREATE OR REPLACE FUNCTION increment_tournament_participants(tournament_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE tournaments 
  SET current_participants = current_participants + 1,
      updated_at = NOW()
  WHERE id = tournament_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to decrement tournament participants
CREATE OR REPLACE FUNCTION decrement_tournament_participants(tournament_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE tournaments 
  SET current_participants = GREATEST(current_participants - 1, 0),
      updated_at = NOW()
  WHERE id = tournament_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to update tournament stats
CREATE OR REPLACE FUNCTION update_tournament_stats()
RETURNS trigger AS $$
BEGIN
  -- Update tournament participant count when participant added/removed
  IF TG_OP = 'INSERT' THEN
    UPDATE tournaments 
    SET current_participants = (
      SELECT COUNT(*) 
      FROM tournament_participants 
      WHERE tournament_id = NEW.tournament_id
    )
    WHERE id = NEW.tournament_id;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE tournaments 
    SET current_participants = (
      SELECT COUNT(*) 
      FROM tournament_participants 
      WHERE tournament_id = OLD.tournament_id
    )
    WHERE id = OLD.tournament_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for automatic participant count updates
DROP TRIGGER IF EXISTS update_tournament_participant_count ON tournament_participants;
CREATE TRIGGER update_tournament_participant_count
  AFTER INSERT OR DELETE ON tournament_participants
  FOR EACH ROW EXECUTE FUNCTION update_tournament_stats();

-- Index for better performance
CREATE INDEX IF NOT EXISTS idx_tournaments_status ON tournaments(status);
CREATE INDEX IF NOT EXISTS idx_tournaments_created_at ON tournaments(created_at);
CREATE INDEX IF NOT EXISTS idx_tournament_participants_tournament_id ON tournament_participants(tournament_id);
CREATE INDEX IF NOT EXISTS idx_tournament_participants_user_id ON tournament_participants(user_id);