constant @primes     = |grep *.is-prime, 2..*;
constant @primorials = [\*] 1, @primes;

my @pp_indexes := |@primorials.pairs.map: {
    .key if ( .value + any(1, -1) ).is-prime
};

say ~ @pp_indexes[ 0 ^.. 20 ]; # Skipping bogus first element.
