USING: arrays kernel lists lists.lazy math math.primes
math.primes.lists prettyprint sequences ;

lprimes                                ! An infinite lazy list of primes
[ dup 2 + dup 4 + 3array ] lmap-lazy   ! Map primes to their triplets (e.g. 2 -> { 2 4 8 })
[ [ prime? ] all? ] lfilter            ! Select triplets which contain only primes
[ first 5500 < ] lwhile                ! Make the list end eventually...
[ . ] leach                            ! Print each item in the list
