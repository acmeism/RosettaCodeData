import: mapping
import: quicksort
import: math

Object method: sum ( coll -- m )
   #+ self reduce dup ifNull: [ drop 0 ] ;

Integer method: properDivs
| i l |
   Array new dup 1 over add ->l
   2 self nsqrt tuck for: i [ self i mod ifFalse: [ i l add  self i / l add ] ]
   sq self == ifTrue: [ l pop drop ]
   dup sort
;

: aliquot( n -- [] )	\ Returns aliquot sequence of n
| end l |
   2 47 pow ->end
   Array new dup n over add ->l
   while ( l size 16 <  l last 0 <> and  l last end <= and ) [ l last properDivs sum  l add ]
;

: aliquotClass( n -- [] s )   \ Returns aliquot sequence and classification
| l i j |
   n aliquot dup ->l
   l last 0   == ifTrue: [ "terminate" return ]
   l second n == ifTrue: [ "perfect" return ]
   3 l at   n == ifTrue: [ "amicable" return ]
   l indexOfFrom(n, 2) ifNotNull: [ "sociable" return ]

   l size loop: i [
      l indexOfFrom(l at(i), i 1+ ) -> j
      j i 1+ == ifTrue: [ "aspiring" return ]
      j ifNotNull: [ "cyclic" return ]
      ]
   "non-terminating"
;
