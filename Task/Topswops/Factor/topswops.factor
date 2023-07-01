USING: formatting kernel math math.combinatorics math.order
math.ranges sequences ;
FROM: sequences.private => exchange-unsafe ;
IN: rosetta-code.topswops

! Reverse a subsequence in-place from 0 to n.
: head-reverse! ( seq n -- seq' )
    dupd [ 2/ ] [ ] bi rot
    [ [ over - 1 - ] dip exchange-unsafe ] 2curry each-integer ;

! Reverse the elements in seq according to the first element.
: swop ( seq -- seq' ) dup first head-reverse! ;

! Determine the number of swops until 1 is the head.
: #swops ( seq -- n )
    0 swap [ dup first 1 = ] [ [ 1 + ] [ swop ] bi* ] until
    drop ;

! Determine the maximum number of swops for a given length.
: topswops ( n -- max )
    [1,b] <permutations> [ #swops ] [ max ] map-reduce ;

: main ( -- )
    10 [1,b] [ dup topswops "%2d: %2d\n" printf ] each ;

MAIN: main
