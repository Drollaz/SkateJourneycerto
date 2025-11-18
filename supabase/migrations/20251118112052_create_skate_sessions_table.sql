/*
  # Create skate sessions table

  1. New Tables
    - `skate_sessions`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references profiles)
      - `place_name` (text)
      - `address` (text)
      - `session_date` (timestamptz)
      - `review` (text)
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

  2. Security
    - Enable RLS on `skate_sessions` table
    - Add policies for authenticated users to:
      - View own sessions
      - Insert own sessions
      - Update own sessions
      - Delete own sessions
*/

CREATE TABLE IF NOT EXISTS skate_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  place_name text NOT NULL,
  address text,
  session_date timestamptz NOT NULL,
  review text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE skate_sessions ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own sessions"
  ON skate_sessions
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own sessions"
  ON skate_sessions
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own sessions"
  ON skate_sessions
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own sessions"
  ON skate_sessions
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Trigger for updated_at
CREATE TRIGGER sessions_updated_at
  BEFORE UPDATE ON skate_sessions
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();