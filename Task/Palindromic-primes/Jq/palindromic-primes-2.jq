def primes:
  2, (range(3;infinite;2) | select(is_prime));

def palindromic_primes_slowly:
  primes | select( tostring|explode | (. == reverse));
