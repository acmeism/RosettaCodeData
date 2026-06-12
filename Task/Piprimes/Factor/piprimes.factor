USING: formatting grouping io lists math.primes
math.primes.lists math.ranges math.statistics sequences ;

21 lprimes lnth [1,b) [ prime? ] cum-count
10 group [ [ "%2d " printf ] each nl ] each
