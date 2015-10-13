include FMS-SI.f
include FMS-SILib.f


\ create a list of VAR objects the right way
\ each: returns a unique object reference
o{ 0 0 0 } dup p:   o{ 0 0 0 }
dup each: drop . 10774016
dup each: drop . 10786896
dup each: drop . 10786912


\ create a list of VAR objects the wrong way
\ each: returns the same object reference
var x
object-list2 list
x list add:
x list add:
x list add:
list p: o{ 0 0 0 }
list each: drop . 1301600
list each: drop . 1301600
list each: drop . 1301600
