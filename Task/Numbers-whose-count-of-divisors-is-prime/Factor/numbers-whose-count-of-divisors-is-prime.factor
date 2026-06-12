USING: formatting grouping io kernel math math.primes
math.primes.factors math.ranges sequences sequences.extras ;
FROM: math.extras => integer-sqrt ;

: odd-prime? ( n -- ? ) dup 2 = [ drop f ] [ prime? ] if ;

: pdc-upto ( n -- seq )
    integer-sqrt [1,b]
    [ sq ] [ divisors length odd-prime? ] map-filter ;

100,000 pdc-upto 10 group [ [ "%-8d" printf ] each nl ] each
