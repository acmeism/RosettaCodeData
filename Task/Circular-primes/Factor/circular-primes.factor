USING: combinators.short-circuit formatting io kernel lists
lists.lazy math math.combinatorics math.functions math.parser
math.primes sequences sequences.extras ;

! Create an ordered infinite lazy list of circular prime
! "candidates" -- the numbers 2, 3, 5 followed by numbers
! composed of only the digits 1, 3, 7, and 9.

: candidates ( -- list )
    L{ "2" "3" "5" "7" } 2 lfrom
    [ "1379" swap selections >list ] lmap-lazy lconcat lappend ;

: circular-prime? ( str -- ? )
    all-rotations {
        [ [ infimum ] [ first = ] bi ]
        [ [ string>number prime? ] all? ]
    } 1&& ;

: circular-primes ( -- list )
    candidates [ circular-prime? ] lfilter ;

: prime-repunits ( -- list )
    7 lfrom [ 10^ 1 - 9 / prime? ] lfilter ;

"The first 19 circular primes are:" print
19 circular-primes ltake [ write bl ] leach nl nl

"The next 4 circular primes, in repunit format, are:" print
4 prime-repunits ltake [ "R(%d) " printf ] leach nl
