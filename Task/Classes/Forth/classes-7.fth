include FMS-SI.f

:class foo   \ begin class foo definition
 ivar x                   \ declare an instance variable named x
 :m put ( n -- ) x ! ;m   \ a method/message definition
 :m init: 10 self put ;m  \ the constructor method
 :m print x ? ;m          \ a print method for x
;class                    \ end class foo definition

foo f1    \ instantiate a foo object, in the dictionary, named f1
f1 print  \ 10   send the print message to object f1
20 f1 put \ send a message with one parameter to the object
f1 print \ 20


: bar  \ bar is a normal Forth function definition
  heap> foo  \ instantiate a nameless object in the heap
  dup print
  30 over put
  dup print
  <free ;  \ destroy the heap object

: bar'  \ bar' is an alternative to bar that uses a local variable
  heap> foo  {: f :}
  f print
  30 f put
  f print
  f <free ;

bar  \ 10 30
bar' \ 10 30
