: luhnTest(n)
| s i |
   n asString reverse ->s
   0 s size loop: i [
      i s at asDigit
      i isEven ifTrue: [ 2 * dup 10 >= ifTrue: [ 9 - ] ] +
      ]
   10 mod ==0 ;
