USING: formatting grouping io kernel lists lists.lazy math
math.primes sequences tools.memory.private ;
IN: rosetta-code.cuban-primes

: cuban-primes ( n -- seq )
    1 lfrom [ [ 3 * ] [ 1 + * ] bi 1 + ] <lazy-map>
    [ prime? ] <lazy-filter> ltake list>array ;

200 cuban-primes 10 <groups>
[ [ commas ] map [ "%10s" printf ] each nl ] each nl

1e5 cuban-primes last commas "100,000th cuban prime is: %s\n"
printf
