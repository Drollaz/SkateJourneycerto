/*
  # Create skate gear tables

  1. New Tables
    - `skate_gear`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references profiles.id)
      - `category` (text) - enum: 'deck', 'truck', 'wheel', 'bearing', 'griptape', 'tool'
      - `name` (text)
      - `specs` (text)
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

    - `deck_details` (extends skate_gear for deck-specific fields)
      - `gear_id` (uuid, references skate_gear.id)
      - `brand` (text)
      - `model` (text)
      - `size` (text)
      - `image_url` (text)
      - `price` (decimal)
      - `purchase_date` (date)
      - `currently_using` (text) - enum: 'Yes', 'No', 'Stock'
      - `condition` (text) - enum: 'New', 'Poor', 'Brooken'

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users to manage their own gear
*/

-- Create enum types
CREATE TYPE gear_category AS ENUM ('deck', 'truck', 'wheel', 'bearing', 'griptape', 'tool');
CREATE TYPE usage_status AS ENUM ('Yes', 'No', 'Stock');
CREATE TYPE condition_status AS ENUM ('New', 'Poor', 'Brooken');

-- Create skate_gear table
CREATE TABLE IF NOT EXISTS skate_gear (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  category gear_category NOT NULL,
  name text NOT NULL,
  specs text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create deck_details table
CREATE TABLE IF NOT EXISTS deck_details (
  gear_id uuid PRIMARY KEY REFERENCES skate_gear(id) ON DELETE CASCADE,
  brand text,
  model text,
  size text,
  image_url text,
  price decimal(10,2),
  purchase_date date,
  currently_using usage_status DEFAULT 'No',
  condition condition_status DEFAULT 'New'
);

-- Enable RLS
ALTER TABLE skate_gear ENABLE ROW LEVEL SECURITY;
ALTER TABLE deck_details ENABLE ROW LEVEL SECURITY;

-- Policies for skate_gear
CREATE POLICY "Users can view own gear"
  ON skate_gear
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own gear"
  ON skate_gear
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own gear"
  ON skate_gear
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own gear"
  ON skate_gear
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Policies for deck_details
CREATE POLICY "Users can view own deck details"
  ON deck_details
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = deck_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own deck details"
  ON deck_details
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = deck_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own deck details"
  ON deck_details
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = deck_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = deck_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own deck details"
  ON deck_details
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = deck_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

-- Add trigger for updated_at on skate_gear
CREATE TRIGGER skate_gear_updated_at
  BEFORE UPDATE ON skate_gear
  FOR EACH ROW
  EXECUTE FUNCTION handle_updated_at();