USING: lists lists.lazy math math.primes math.primes.lists prettyprint ;

50 lprimes [ 2 * 1 + prime? ] lfilter ltake [ . ] leach
