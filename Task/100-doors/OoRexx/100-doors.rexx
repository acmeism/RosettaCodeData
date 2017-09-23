doors = .array~new(100)    -- array containing all of the doors
do i = 1 to doors~size     -- initialize with a collection of closed doors
   doors[i] = .door~new(i)
end

do inc = 1 to doors~size
  do d = inc to doors~size by inc
    doors[d]~toggle
  end
end
say "The open doors after 100 passes:"
do door over doors
  if door~isopen then say door
end

::class door           -- simple class to represent a door
::method init          -- initialize an instance of a door
  expose id state      -- instance variables of a door
  use strict arg id    -- set the id
  state = .false       -- initial state is closed

::method toggle        -- toggle the state of the door
  expose state
  state = \state

::method isopen        -- test if the door is open
  expose state
  return state

::method string        -- return a string value for a door
  expose state id
  if state then return "Door" id "is open"
  else return "Door" id "is closed"

::method state         -- return door state as a descriptive string
  expose state
  if state then return "open"
  else return "closed"
