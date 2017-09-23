p = .point~new(3,2)
c = .circle~new(,2,6)

p~print
c~print

::class point
::method init
  expose x y
  use strict arg x = 0, y = 0   -- defaults to 0 for any non-specified coordinates

::attribute x
::attribute y

::method print
  expose x y
  say "A point at location ("||x","y")"

::class circle
::method init
  expose x y radius
  use strict arg x = 0, y = 0, radius = 0

::attribute radius
::attribute x
::attribute y

::method print
  expose radius x y
  say "A circle of radius" radius "centered at location ("||x","y")"
