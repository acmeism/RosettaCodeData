USING: io kernel math.primes.factors math.ranges prettyprint
sequences ;

: .factors ( n -- )
    dup pprint ": " write factors
    [ " × " write ] [ pprint ] interleave nl ;

"1: 1" print 2 20 [a,b] [ .factors ] each
