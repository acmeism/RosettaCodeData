USING: combinators formatting io kernel math math.primes.factors
math.ranges sequences ;
IN: rosetta-code.totient-function

: Φ ( n -- m )
    {
        { [ dup 1 < ] [ drop 0 ] }
        { [ dup 1 = ] [ drop 1 ] }
        [
            dup unique-factors
            [ 1 [ 1 - * ] reduce ] [ product ] bi / *
        ]
    } cond ;

: show-info ( n -- )
    [ Φ ] [ swap 2dup - 1 = ] bi ", prime" "" ?
    "Φ(%2d) = %2d%s\n" printf ;

: totient-demo ( -- )
    25 [1,b] [ show-info ] each nl 0 100,000 [1,b] [
        [ dup Φ - 1 = [ 1 + ] when ]
        [ dup { 100 1,000 10,000 100,000 } member? ] bi
        [ dupd "%4d primes <= %d\n" printf ] [ drop ] if
    ] each drop ;

MAIN: totient-demo
