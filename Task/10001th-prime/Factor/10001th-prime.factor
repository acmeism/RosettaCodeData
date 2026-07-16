USING: math math.primes prettyprint ;
IN: prime-10001

: main ( -- x )
    2 10,000 [ next-prime ] times ;

main .
