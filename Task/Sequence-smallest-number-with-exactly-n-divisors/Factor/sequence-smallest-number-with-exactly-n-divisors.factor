USING: fry kernel lists lists.lazy math math.primes.factors
prettyprint sequences ;

: A005179 ( -- list )
    1 lfrom [
        1 swap '[ dup divisors length _ = ] [ 1 + ] until
    ] lmap-lazy ;

15 A005179 ltake list>array .
