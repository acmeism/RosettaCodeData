USING: formatting fry io kernel math math.functions math.primes
math.primes.factors memoize prettyprint sequences ;
IN: rosetta-code.long-primes

: period-length ( p -- len )
    [ 1 - divisors ] [ '[ 10 swap _ ^mod 1 = ] ] bi find nip ;

MEMO: long-prime? ( p -- ? ) [ period-length ] [ 1 - ] bi = ;

: .lp<=500 ( -- )
    500 primes-upto [ long-prime? ] filter
    "Long primes <= 500:" print [ pprint bl ] each nl ;

: .#lp<=n ( n -- )
    dup primes-upto [ long-prime? t = ] count swap
    "%-4d long primes <= %d\n" printf ;

: long-primes-demo ( -- )
    .lp<=500 nl
    { 500 1,000 2,000 4,000 8,000 16,000 32,000 64,000 }
    [ .#lp<=n ] each ;

MAIN: long-primes-demo
