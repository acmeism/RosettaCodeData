include FMS-SI.f

:class animal
  variable cnt 0 cnt ! \ static instance variable
  :m init: 1 cnt +! ;m
  :m cnt: cnt @ . ;m
;class

:class cat <super animal
  :m speak ." meow" ;m
;class

:class dog <super animal
  :m speak ." woof" ;m
;class

cat Frisky   \ instantiate a cat object named Frisky
dog Sparky   \ instantiate a dog object named Sparky

\ The class method cnt: will return the number of animals instantiated
\ regardless of which animal object is used.

\ The instance method speak will respond differently depending
\ on the class of the instance object.

Frisky cnt:  \ => 2 ok
Sparky cnt:  \ => 2 ok
Frisky speak \ => meow ok
Sparky speak \ => woof ok
