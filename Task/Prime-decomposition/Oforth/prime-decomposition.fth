: factors(n)   // ( aInteger -- aList )
| k p |
   ListBuffer new
   2 ->k
   n nsqrt ->p
   while( k p <= ) [
      n k /mod swap ifZero: [
         dup ->n nsqrt ->p
         k over add continue
         ]
      drop k 1+ ->k
      ]
   n 1 > ifTrue: [ n over add ]
   dup freeze ;
