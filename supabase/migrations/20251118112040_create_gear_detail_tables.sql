/*
  # Add detail tables for skateboarding gear components

  1. New Tables
    - `truck_details`: Stores specific details for trucks
    - `wheel_details`: Stores specific details for wheels
    - `bearing_details`: Stores specific details for bearings
    - `griptape_details`: Stores specific details for griptape
    - `tool_details`: Stores specific details for tools

  2. Changes
    - Added specific detail tables for each gear category
    - Each table references the main skate_gear table
    - Added appropriate columns for each gear type

  3. Security
    - Enable RLS on all new tables
    - Add policies for CRUD operations
*/

-- Create truck_details table
CREATE TABLE IF NOT EXISTS truck_details (
  gear_id uuid PRIMARY KEY REFERENCES skate_gear(id) ON DELETE CASCADE,
  brand text,
  width text,
  height text,
  image_url text,
  price decimal(10,2),
  color text,
  axle_type text,
  weight decimal(10,2),
  currently_using usage_status DEFAULT 'No',
  condition condition_status DEFAULT 'New'
);

-- Create wheel_details table
CREATE TABLE IF NOT EXISTS wheel_details (
  gear_id uuid PRIMARY KEY REFERENCES skate_gear(id) ON DELETE CASCADE,
  brand text,
  size text,
  image_url text,
  price decimal(10,2),
  diameter integer,
  durometer text,
  contact_patch integer,
  color text,
  currently_using usage_status DEFAULT 'No',
  condition condition_status DEFAULT 'New'
);

-- Create bearing_details table
CREATE TABLE IF NOT EXISTS bearing_details (
  gear_id uuid PRIMARY KEY REFERENCES skate_gear(id) ON DELETE CASCADE,
  brand text,
  image_url text,
  price decimal(10,2),
  abec_rating text,
  material text,
  shields_type text,
  currently_using usage_status DEFAULT 'No',
  condition condition_status DEFAULT 'New'
);

-- Create griptape_details table
CREATE TABLE IF NOT EXISTS griptape_details (
  gear_id uuid PRIMARY KEY REFERENCES skate_gear(id) ON DELETE CASCADE,
  brand text,
  image_url text,
  price decimal(10,2),
  width text,
  length text,
  grit text,
  color text,
  currently_using usage_status DEFAULT 'No',
  condition condition_status DEFAULT 'New'
);

-- Create tool_details table
CREATE TABLE IF NOT EXISTS tool_details (
  gear_id uuid PRIMARY KEY REFERENCES skate_gear(id) ON DELETE CASCADE,
  brand text,
  image_url text,
  price decimal(10,2),
  tool_type text,
  material text,
  included_tools text[],
  color text,
  condition condition_status DEFAULT 'New'
);

-- Enable RLS
ALTER TABLE truck_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE wheel_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE bearing_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE griptape_details ENABLE ROW LEVEL SECURITY;
ALTER TABLE tool_details ENABLE ROW LEVEL SECURITY;

-- Policies for truck_details
CREATE POLICY "Users can view own truck details"
  ON truck_details
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = truck_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own truck details"
  ON truck_details
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = truck_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own truck details"
  ON truck_details
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = truck_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = truck_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own truck details"
  ON truck_details
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = truck_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

-- Policies for wheel_details
CREATE POLICY "Users can view own wheel details"
  ON wheel_details
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = wheel_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own wheel details"
  ON wheel_details
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = wheel_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own wheel details"
  ON wheel_details
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = wheel_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = wheel_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own wheel details"
  ON wheel_details
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = wheel_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

-- Policies for bearing_details
CREATE POLICY "Users can view own bearing details"
  ON bearing_details
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = bearing_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own bearing details"
  ON bearing_details
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = bearing_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own bearing details"
  ON bearing_details
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = bearing_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = bearing_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own bearing details"
  ON bearing_details
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = bearing_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

-- Policies for griptape_details
CREATE POLICY "Users can view own griptape details"
  ON griptape_details
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = griptape_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own griptape details"
  ON griptape_details
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = griptape_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own griptape details"
  ON griptape_details
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = griptape_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = griptape_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own griptape details"
  ON griptape_details
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = griptape_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

-- Policies for tool_details
CREATE POLICY "Users can view own tool details"
  ON tool_details
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = tool_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own tool details"
  ON tool_details
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = tool_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own tool details"
  ON tool_details
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = tool_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = tool_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own tool details"
  ON tool_details
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM skate_gear
      WHERE skate_gear.id = tool_details.gear_id
      AND skate_gear.user_id = auth.uid()
    )
  );