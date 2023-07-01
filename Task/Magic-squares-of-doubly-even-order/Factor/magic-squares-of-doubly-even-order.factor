USING: arrays combinators.short-circuit formatting fry
generalizations kernel math math.matrices prettyprint sequences
;
IN: rosetta-code.doubly-even-magic-squares

: top?    ( loc n -- ? ) [ second ] dip 1/4 * <  ;
: bottom? ( loc n -- ? ) [ second ] dip 3/4 * >= ;
: left?   ( loc n -- ? ) [ first  ] dip 1/4 * <  ;
: right?  ( loc n -- ? ) [ first  ] dip 3/4 * >= ;
: corner? ( loc n -- ? )
    {
        [ { [ top?    ] [ left?  ] } ]
        [ { [ top?    ] [ right? ] } ]
        [ { [ bottom? ] [ left?  ] } ]
        [ { [ bottom? ] [ right? ] } ]
    } [ 2&& ] map-compose 2|| ;

: center? ( loc n -- ? )
    { [ top? ] [ bottom? ] [ left? ] [ right? ] } [ not ]
    map-compose 2&& ;

: backward? ( loc n -- ? ) { [ corner? ] [ center? ] } 2|| ;
: forward   ( loc n -- m ) [ first2 ] dip * 1 + + ;
: backward  ( loc n -- m ) tuck forward [ sq ] dip - 1 + ;

: (doubly-even-magic-square) ( n -- matrix )
    [ dup 2array matrix-coordinates flip ] [ 3 dupn ] bi
    '[ dup _ backward? [ _ backward ] [ _ forward ] if ]
    matrix-map ;

ERROR: invalid-order order ;

: check-order ( n -- )
    dup { [ zero? not ] [ 4 mod zero? ] } 1&& [ drop ]
    [ invalid-order ] if ;

: doubly-even-magic-square ( n -- matrix )
    dup check-order (doubly-even-magic-square) ;

: main ( -- )
    { 4 8 12 } [
        dup doubly-even-magic-square dup
        [ "Order: %d\n" printf ]
        [ simple-table. ]
        [ first sum "Magic constant: %d\n\n" printf ] tri*
    ] each ;

MAIN: main
