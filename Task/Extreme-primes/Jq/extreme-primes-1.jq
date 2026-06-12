def primes:
  2 | recurse(nextprime);

def extremes:
  foreach primes as $p (0; . + $p)
  | select(is_prime);

limit(30; extremes)
