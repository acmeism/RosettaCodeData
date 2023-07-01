USING: assocs formatting kernel locals make math
math.primes.factors sequences.extras ;
IN: rosetta-code.anti-primes

<PRIVATE

: count-divisors ( n -- m )
    dup 1 = [ group-factors values [ 1 + ] map-product ] unless ;

: (n-anti-primes) ( md n count -- ?md' n' ?count' )
    dup 0 >
    [| max-div! n count! |
        n count-divisors :> d
        d max-div > [ d max-div! n , count 1 - count! ] when
        max-div n dup 60 >= 20 1 ? + count (n-anti-primes)
    ] when ;

PRIVATE>

: n-anti-primes ( n -- seq )
    [ 0 1 ] dip [ (n-anti-primes) 3drop ] { } make ;

: anti-primes-demo ( -- )
    20 n-anti-primes "First 20 anti-primes:\n%[%d, %]\n" printf ;

MAIN: anti-primes-demo
