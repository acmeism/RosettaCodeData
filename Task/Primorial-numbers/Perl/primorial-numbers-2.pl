use ntheory ":all";
say length( vecprod( @{primes( nth_prime(10**6) )} ) );
