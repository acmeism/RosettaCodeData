include FMS-SI.f

99 value x  \ create a global variable named x

:class foo
 ivar x  \ this x is private to the class foo
 :m init: 10 x ! ;m  \ constructor
 :m print x ? ;m
;class

foo f1    \ instantiate a foo object
f1 print  \ 10

x .  \ 99  x is a globally scoped name

50 .. f1.x !  \ use the dot parser to access the private x without a message
f1 print  \ 50
