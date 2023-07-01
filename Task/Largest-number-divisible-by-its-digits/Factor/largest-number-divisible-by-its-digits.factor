USING: io kernel math math.combinatorics math.parser math.ranges
sequences tools.time ;
IN: rosetta-code.largest-divisible

: all-div? ( seq -- ? )
    [ string>number ] [ string>digits ] bi [ mod ] with map
    sum 0 = ;

: n-digit-all-div ( n -- seq )
    "12346789" swap <combinations>
    [ [ all-div? ] filter-permutations ] map concat ;

: largest-divisible ( -- str )
    8 [ dup n-digit-all-div dup empty? ] [ drop 1 - ] while
    nip supremum ;

: largest-divisible-demo ( -- )
    [ largest-divisible print ] time ;

MAIN: largest-divisible-demo
