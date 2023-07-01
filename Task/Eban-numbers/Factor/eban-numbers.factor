USING: arrays formatting fry io kernel math math.functions
math.order math.ranges prettyprint sequences ;

: eban? ( n -- ? )
    1000000000 /mod 1000000 /mod 1000 /mod
    [ dup 30 66 between? [ 10 mod ] when ] tri@ 4array
    [ { 0 2 4 6 } member? ] all? ;

: .eban ( m n -- ) "eban numbers in [%d, %d]: " printf ;
: eban ( m n q -- o ) '[ 2dup .eban [a,b] [ eban? ] @ ] call ; inline
: .eban-range ( m n -- ) [ filter ] eban "%[%d, %]\n" printf ;
: .eban-count ( m n -- ) "count of " write [ count ] eban . ;

1 1000 1000 4000 [ .eban-range ] 2bi@
4 9 [a,b] [ [ 1 10 ] dip ^ .eban-count ] each
