USING: assocs combinators.extras io kernel math math.parser
math.ranges prettyprint sequences splitting ;
IN: rosetta-code.general-fizzbuzz

: prompt ( -- str ) ">" write readln ;

: get-factor ( -- seq )
    prompt " " split first2 [ string>number ] dip
    { } 2sequence ;

: get-input ( -- assoc n )
    prompt string>number [1,b] [ get-factor ] thrice
    { } 3sequence swap ;

: fizzbuzz ( assoc n -- )
    swap dupd [ drop swap mod 0 = ] with assoc-filter
    dup empty? [ drop . ] [ nip values concat print ] if ;

: main ( -- ) get-input [ fizzbuzz ] with each ;

MAIN: main
