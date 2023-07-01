p = .point~new(3,4)
say "x =" p~x
say "y =" p~y

::class point
::method init
  expose x y
  use strict arg x = 0, y = 0   -- defaults to 0 for any non-specified coordinates

::attribute x
::attribute y
