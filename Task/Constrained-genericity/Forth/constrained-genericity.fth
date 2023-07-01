include FMS-SI.f
include FMS-SILib.f
:class Eatable
   :m eat ." successful eat " ;m
;class

\ FoodBox is defined without inspecting for the eat message
:class FoodBox
  object-list eatable-types
  :m init: eatable-types init: ;m
  :m add: ( obj -- )
     dup is-kindOf Eatable
     if   eatable-types add:
     else drop ." not an eatable type "
     then ;m
  :m test
     begin eatable-types each:
     while eat
     repeat ;m
;class

FoodBox aFoodBox
Eatable aEatable
aEatable aFoodBox add:  \ add the e1 object to the object-list
aFoodBox test  \ => successful eat

:class brick
 :m eat cr ." successful eat " ;m
;class

brick abrick  \ create an object that is not eatable
abrick aFoodBox add: \ => not an eatable type

:class apple <super Eatable
;class

apple anapple
anapple aFoodBox add:
aFoodBox test  \ => successful eat successful eat
