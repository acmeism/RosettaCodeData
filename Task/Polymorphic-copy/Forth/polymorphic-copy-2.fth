include FMS-SI.f

:class T
 ivar container  \ can contain an object of any type
 :m put ( obj -- ) container ! ;m
 :m init: self self put ;m \ initially container holds self
 :m print ." class is T" ;m
 :m print-container container @ print ;m
;class

:class S <super T    \ subclass S from T
 :m print ." class is S" ;m \ override T's print method
;class

: ecopy {: obj1 -- obj2 :} \ make an exact copy of obj
  obj1 dup >class dfa @
  obj1 heap: dup >r swap move r> ;

T obj-t  \ instantiate a T object
obj-t print-container \ class is T

S obj-s  \ instantiate an S object
obj-s ecopy obj-t put  \ make an exact copy of S object and store in T object

obj-t print-container \ class is S
