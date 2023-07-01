USING: assocs continuations formatting io kernel math
math.ranges sequences ;

: (next-hailstone) ( count value -- count' value' )
    [ 1 + ] [ dup even? [ 2/ ] [ 3 * 1 + ] if ] bi* ;

: next-hailstone ( count value -- count' value' )
    dup 1 = [ (next-hailstone) ] unless ;

: make-environments ( -- seq ) 12 [ 0 ] replicate 12 [1,b] zip ;

: step ( seq -- new-seq )
    [ [ dup "%4d " printf next-hailstone ] with-datastack ] map
    nl ;

: done? ( seq -- ? ) [ second 1 = ] all? ;

make-environments
[ dup done? ] [ step ] until nl
"Counts:" print
[ [ drop "%4d " printf ] with-datastack drop ] each nl
