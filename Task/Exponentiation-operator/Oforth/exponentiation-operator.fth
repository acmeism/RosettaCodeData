: powint(r, n)
| i |
   1 n abs loop: i [ r * ]
   n isNegative ifTrue: [ inv ] ;

2 3 powint println
2 powint(3) println
1.2 4 powint println
1.2 powint(4) println
