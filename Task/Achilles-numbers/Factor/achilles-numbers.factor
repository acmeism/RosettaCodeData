USING: assocs combinators.short-circuit formatting grouping io
kernel lists lists.lazy math math.functions math.primes.factors
prettyprint ranges sequences ;

: achilles? ( n -- ? )
    group-factors values {
        [ [ 1 > ] all? ]
        [ unclip-slice [ simple-gcd ] reduce 1 = ]
    } 1&& ;

: achilles ( -- list )
    2 lfrom [ achilles? ] lfilter ;

: strong-achilles ( -- list )
    achilles [ totient achilles? ] lfilter ;

: show ( n list -- ) ltake list>array 10 group simple-table. ;

: <order-of-magnitude> ( n -- range )
    1 - 10^ dup 10 * [a..b) ;

"First 50 Achilles numbers:" print
50 achilles show nl

"First 30 strong Achilles numbers:" print
30 strong-achilles show nl

"Number of Achilles numbers with" print
{ 2 3 4 5 } [
    dup <order-of-magnitude> [ achilles? ] count
    "%d digits: %d\n" printf
] each
