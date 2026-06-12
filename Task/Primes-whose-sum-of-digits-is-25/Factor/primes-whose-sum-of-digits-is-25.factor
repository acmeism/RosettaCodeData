USING: kernel lists lists.lazy math math.primes.lists prettyprint ;

: digit-sum ( n -- sum )
    0 swap [ 10 /mod rot + swap ] until-zero ;

: lprimes25 ( -- list ) lprimes [ digit-sum 25 = ] lfilter ;

lprimes25 [ 5,000 < ] lwhile [ . ] leach
