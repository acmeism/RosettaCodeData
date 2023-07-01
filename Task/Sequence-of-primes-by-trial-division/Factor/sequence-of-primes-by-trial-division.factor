USING: combinators kernel lists lists.lazy math math.functions
math.ranges prettyprint sequences ;

: prime? ( n -- ? )
    {
        { [ dup 2 < ] [ drop f ] }
        { [ dup even? ] [ 2 = ] }
        [ 3 over sqrt 2 <range> [ mod 0 > ] with all? ]
    } cond ;

! Create an infinite lazy list of primes.
: primes ( -- list ) 0 lfrom [ prime? ] lfilter ;

! Show the first fifteen primes.
15 primes ltake list>array .
