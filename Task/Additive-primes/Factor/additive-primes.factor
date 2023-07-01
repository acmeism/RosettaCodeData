USING: formatting grouping io kernel math math.primes
prettyprint sequences ;

: sum-digits ( n -- sum )
    0 swap [ 10 /mod rot + swap ] until-zero ;

499 primes-upto [ sum-digits prime? ] filter
[ 9 group simple-table. nl ]
[ length "Found  %d  additive primes  <  500.\n" printf ] bi
