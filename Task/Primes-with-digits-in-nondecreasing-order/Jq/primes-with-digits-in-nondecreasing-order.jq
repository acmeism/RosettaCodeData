def digits: tostring | explode;

# Input: an upper bound, or `infinite`
# Output: a stream
def primes_with_nondecreasing_digits:
  (2, range(3; .; 2))
  | select( (digits | (. == sort)) and is_prime);

1000 | primes_with_nondecreasing_digits
