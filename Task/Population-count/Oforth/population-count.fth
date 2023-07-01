: popcount(n)
   0 while ( n ) [ n isOdd + n bitRight(1) ->n ] ;

: test
| i count |
   30 seq map(#[ 3 swap 1- pow ]) map(#popcount) println

   0 ->count
   0 while( count 30 <> ) [ dup popcount isEven ifTrue: [ dup . count 1+ ->count ] 1+ ] drop printcr

   0 ->count
   0 while( count 30 <> ) [ dup popcount isOdd ifTrue: [ dup . count 1+ ->count ] 1+ ] drop ;
