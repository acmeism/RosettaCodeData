include FMS-SI.f
include FMS-SILib.f

: (where) ( class-xt where-dfa -- flag )
     swap >body { where-dfa class-dfa }
     begin
       class-dfa ['] object >body <>
     while
       class-dfa where-dfa = if true exit then
       class-dfa sfa @  to class-dfa
     repeat false ;

: where ( class-xt "classname" -- flag )
  ' >body state @
  if postpone literal postpone (where)
  else (where)
  then ; immediate

:class Eatable
   :m eat cr ." successful eat" ;m
;class

\ FoodBox is defined without using eat in any way.
:class FoodBox
  object-list eatable-types
  :m fill: { n class-xt -- }
     class-xt where Eatable
     if   n 0 do class-xt eatable-types xtadd: loop
     else ." not an eatable type "
     then ;m
  :m get ( -- obj ) eatable-types ;m
;class

: test ( obj -- )  \ send the eat message to each object in the object-list
  begin dup each:
  while eat
  repeat drop ;

FoodBox fb
3 ' Eatable fb fill:  \ fill the object-list with 3 objects of class Eatable
fb get test
successful eat
successful eat
successful eat

FoodBox fb1
5 ' object fb1 fill: \ => not an eatable type

:class apple <super Eatable
;class

:class green-apple <super apple
;class

5 ' green-apple fb1 fill:
fb1 get test
successful eat
successful eat
successful eat
successful eat
successful eat
