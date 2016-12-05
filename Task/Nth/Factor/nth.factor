USING: math kernel combinators math.ranges math.parser
    sequences io ;
IN: nth

: tens-digit ( n -- n ) 10 [ /i ] [ mod ] bi ;

: teens? ( n -- ? ) tens-digit 1 = ;

: non-teen-suffix ( n -- str )
    10 mod {
        { 1 [ "st" ] }
        { 2 [ "nd" ] }
        { 3 [ "rd" ] }
        [ drop "th" ]
    } case ;

: ordinal-suffix ( n -- str )
    dup teens? [ drop 0 ] when non-teen-suffix ;

: join-suffix ( n -- str ) dup ordinal-suffix
    [ number>string ] dip append ;

: main ( -- )
    0 25 250 265 1000 1025 [ [a,b] ] 2tri@
    [ [ join-suffix ] map ] tri@
    [ [ bl ] [ write ] interleave nl ] tri@ ;

MAIN: main
