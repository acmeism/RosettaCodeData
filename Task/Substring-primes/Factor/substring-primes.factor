USING: combinators kernel math math.primes prettyprint sequences ;

:: ssp? ( n -- ? )
    {
        { [ n prime? not ] [ f ] }
        { [ n 10 < ] [ t ] }
        { [ n 100 mod prime? not ] [ f ] }
        { [ n 10 mod prime? not ] [ f ] }
        { [ n 10 /i prime? not ] [ f ] }
        { [ n 100 < ] [ t ] }
        { [ n 100 /i prime? not ] [ f ] }
        { [ n 100 mod 10 /i prime? not ] [ f ] }
        [ t ]
    } cond ;

500 <iota> [ ssp? ] filter .
