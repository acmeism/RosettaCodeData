USING: combinators formatting io kernel math math.parser
sequences ;
IN: rosetta-code.middle-three-digits

CONSTANT: test-values { 123 12345 1234567 987654321 10001 -10001
    -123 -100 100 -12345 1 2 -1 -10 2002 -2002 0 }

: middle-three ( str -- str' ) [ midpoint@ ] keep
    [ [ 1 - ] [ 2 + ] bi ] dip subseq ;

: too-short ( -- ) "Number must have at least three digits."
    print ;

: number-even ( -- ) "Number must have an odd number of digits."
    print ;

: process ( n -- )
    abs number>string {
        { [ dup length 3 < ] [ drop too-short ] }
        { [ dup length even? ] [ drop number-even ] }
        [ middle-three print ]
    } cond ;

: main ( -- ) test-values [ dup "%9d : " printf process ] each ;

MAIN: main
