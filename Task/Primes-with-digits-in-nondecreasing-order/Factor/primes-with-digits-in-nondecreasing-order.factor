USING: grouping lists lists.lazy math math.primes.lists
present prettyprint ;

lprimes [ present [ <= ] monotonic? ] lfilter
[ 1000 < ] lwhile [ . ] leach
