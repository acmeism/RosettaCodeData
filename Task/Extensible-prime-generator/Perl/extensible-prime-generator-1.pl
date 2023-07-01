use Math::Prime::Util qw(nth_prime prime_count primes);
# Direct solutions.
# primes([start],end) returns an array reference with all primes in the range
# prime_count([start],end) uses sieving or LMO to return fast prime counts
# nth_prime(n) does just that.  It runs quite fast for native size inputs.
say "First 20: ", join(" ", @{primes(nth_prime(20))});
say "Between 100 and 150: ", join(" ", @{primes(100,150)});
say prime_count(7700,8000), " primes between 7700 and 8000";
say "${_}th prime: ", nth_prime($_) for map { 10**$_ } 1..8;
