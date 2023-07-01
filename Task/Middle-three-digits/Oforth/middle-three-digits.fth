: middle3
| s sz |
   abs asString dup ->s size ->sz
   sz 3 <    ifTrue: [ "Too short" println return ]
   sz isEven ifTrue: [ "Not odd number of digits" println return ]
   sz 3 - 2 / 1+  dup 2 + s extract ;
