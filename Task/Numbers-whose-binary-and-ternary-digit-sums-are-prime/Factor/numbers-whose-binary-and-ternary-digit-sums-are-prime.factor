USING: combinators combinators.short-circuit formatting io lists
lists.lazy math math.parser math.primes sequences ;

: dsum ( n base -- sum ) >base [ digit> ] map-sum ;
: dprime? ( n base -- ? ) dsum prime? ;
: 23prime? ( n -- ? ) { [ 2 dprime? ] [ 3 dprime? ] } 1&& ;
: l23primes ( -- list ) 1 lfrom [ 23prime? ] lfilter ;

: 23prime. ( n -- )
    {
        [ ]
        [ >bin ]
        [ 2 dsum ]
        [ 3 >base ]
        [ 3 dsum ]
    } cleave
    "%-8d %-9s %-6d %-7s %d\n" printf ;

"Base 10  Base 2    (sum)  Base 3  (sum)" print
l23primes [ 200 < ] lwhile [ 23prime. ] leach
