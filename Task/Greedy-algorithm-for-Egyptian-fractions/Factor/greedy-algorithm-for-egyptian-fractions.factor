USING: backtrack formatting fry kernel locals make math
math.functions math.ranges sequences ;
IN: rosetta-code.egyptian-fractions

: >improper ( r -- str ) >fraction "%d/%d" sprintf ;

: improper ( x y -- a b ) [ /i ] [ [ rem ] [ nip ] 2bi / ] 2bi ;

:: proper ( x y -- a b )
    y x / ceiling :> d1 1 d1 / y neg x rem y d1 * / ;

: expand ( a -- b c )
    >fraction 2dup > [ improper ] [ proper ] if ;

: egyptian-fractions ( x -- seq )
    [ [ expand [ , ] dip dup 0 = not ] loop drop ] { } make ;

: part1 ( -- )
    43/48 5/121 2014/59 [
        [ >improper ] [ egyptian-fractions ] bi
        "%s => %[%u, %]\n" printf
    ] tri@ ;

: all-longest ( seq -- seq )
    dup longest length '[ length _ = ] filter ;

: (largest-denominator) ( seq -- n )
    [ denominator ] map supremum ;

: most-terms ( seq -- )
    all-longest [ [ sum ] map ] [ first length ] bi
    "most terms: %[%u, %] => %d\n" printf ;

: largest-denominator ( seq -- )
    [ (largest-denominator) ] supremum-by
    [ sum ] [ (largest-denominator) ] bi
    "largest denominator: %u => %d\n" printf ;

: part2 ( -- )
    [
        99 [1,b] amb-lazy dup [1,b] amb-lazy swap /
        egyptian-fractions
    ] bag-of [ most-terms ] [ largest-denominator ] bi ;

: egyptian-fractions-demo ( -- ) part1 part2 ;

MAIN: egyptian-fractions-demo
