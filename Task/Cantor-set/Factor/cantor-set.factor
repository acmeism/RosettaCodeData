USING: grouping.extras io kernel math sequences
sequences.repeating ;
IN: rosetta-code.cantor-set

CONSTANT: width 81
CONSTANT: depth 5

: cantor ( n -- seq )
    dup 0 = [ drop { 0 1 } ]
    [ 1 - cantor [ 3 / ] map dup [ 2/3 + ] map append ] if ;

! Produces a sequence of lengths from a Cantor set, depending on
! width. Even indices are solid; odd indices are blank.
! e.g. 2 cantor gaps -> { 9 9 9 27 9 9 9 }
!
: gaps ( seq -- seq )
    [ width * ] map [ - abs ] 2clump-map ;

: print-cantor ( n -- )
    cantor gaps [ even? "#" " " ? swap repeat ] map-index
    concat print ;

depth <iota> [ print-cantor ] each
