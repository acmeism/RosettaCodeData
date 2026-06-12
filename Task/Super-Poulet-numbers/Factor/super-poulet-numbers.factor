USING: combinators.short-circuit io kernel lists lists.lazy math
math.functions math.primes math.primes.factors prettyprint
sequences ;

: super-poulet? ( n -- ? )
    {
        [ prime? not ]
        [ [ 1 - 2^ ] keep mod 1 = ]
        [ divisors [ [ 2^ 2 - ] keep divisor? ] all? ]
    } 1&& ;

: super-poulets ( -- list )
    1 lfrom [ super-poulet? ] lfilter ;

20 super-poulets ltake [ pprint bl ] leach nl
