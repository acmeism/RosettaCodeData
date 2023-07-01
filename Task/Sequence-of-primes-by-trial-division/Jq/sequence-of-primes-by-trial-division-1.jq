# Produce a (possibly empty) stream of primes in the range [m,n], i.e. m <= p <= n
def primes(m; n):
  ([m,2] | max) as $m
  | if $m > n then empty
    elif $m == 2 then 2, primes(3;n)
    else (1 + (2 * range($m/2 | floor; (n + 1) /2 | floor))) | select( is_prime )
    end;
