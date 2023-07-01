import: console

: cmpInt
| a b |
   doWhile: [ System.Console askln asInteger dup ->a isNull ]
   doWhile: [ System.Console askln asInteger dup ->b isNull ]

   a b <  ifTrue: [ System.Out a << " is less than " << b << cr ]
   a b == ifTrue: [ System.Out a << " is equal to " << b << cr ]
   a b >  ifTrue: [ System.Out a << " is greater than " << b << cr ] ;
