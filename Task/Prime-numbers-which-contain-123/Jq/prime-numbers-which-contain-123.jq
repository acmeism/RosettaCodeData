def count(stream): reduce stream as $i (0; .+1);

def digits: tostring | explode;

# Input: an upper bound, or `infinite`
def primes_with_123:
  ("123"| digits) as $d123
  | range(123; .; 2))
  | select( (digits | index($d123)) and is_prime);

100000 | primes_with_123,

(1000000
 | "\nThere are \(count(primes_with_123)) \"123\" primes less than \(.).")
