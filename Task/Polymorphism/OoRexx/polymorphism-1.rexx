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

::class circle subclass point
::method init
  expose radius
  use strict arg x = 0, y = 0, radius = 0
  self~init:super(x, y)        -- call superclass constructor

::attribute radius

::method print
  expose radius
  say "A circle of radius" radius "centered at location ("||self~x","self~y")"
