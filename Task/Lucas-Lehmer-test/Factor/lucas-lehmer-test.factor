USING: io math.primes.lucas-lehmer math.ranges prettyprint
sequences ;

47 [1,b] [ lucas-lehmer ] filter
"Mersenne primes:" print
[ "M" write pprint bl ] each nl
