-- Import module
local sql = require("ljsqlite3")

-- Open connection to database file
local conn = sql.open("address.sqlite")

-- Create address table unless it already exists
conn:exec[[
CREATE TABLE IF NOT EXISTS address(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  street TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  zip TEXT NOT NULL)
]]

-- Explicitly close connection
conn:close()
