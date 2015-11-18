include FMS-SI.f
include FMS-SILib.f


\ FMS doesn't have the ability to add instance variables
\ or methods at run time.  But it is very simple to add any number of
\ objects of any type to a single object at run time.  The added
\ objects are then accessible via an index number.

:class foo
  object-list inst-objects \ a dynamically growable object container
  :m add: ( obj -- ) inst-objects add: ;m
  :m at: ( idx -- obj ) inst-objects at: ;m
;class

foo foo1

: main
  heap> string foo1 add:
  heap> fvar   foo1 add:

  s" Now is the time " 0 foo1 at: !:
  3.14159e             1 foo1 at: !:

  0 foo1 at: p: \ send the print message to indexed object 0
  1 foo1 at: p: \ send the print message to indexed object 1
;

main \ => Now is the time 3.14159
