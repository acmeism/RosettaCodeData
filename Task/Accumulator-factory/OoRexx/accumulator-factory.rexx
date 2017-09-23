x = .accumulator~new(1)    -- new accumulator with initial value of "1"
x~call(5)
x~call(2.3)
say "Accumulator value is now" x    -- displays current value

-- an accumulator class instance can be instantiated and
-- used to sum up a series of numbers
::class accumulator
::method init    -- instance initializer...sets the accumulator initial value
  expose sum
  use strict arg sum = 0 -- sets default sum value if not specified

-- perform the accumulator function
::method call
  expose sum
  use strict arg n
  sum += n       -- bump the accumulator
  return sum     -- return the new value

-- extra credit...display the current accumulator value
::method string
  expose sum
  return sum
