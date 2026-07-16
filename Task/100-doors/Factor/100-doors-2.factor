USING: formatting math math.primes.factors ranges sequences ;
IN: rosetta.doors2

: main ( -- )
    100 [1..b] [ divisors length odd? ] filter "Open %[%d, %]\n" printf ;

main
