def primes:
  2, range(3; infinite; 2) | select(is_prime);

# generate an infinite stream of primorials
def primorials:
  foreach primes as $p (1; .*$p; .);

# Emit a sorted array of the first $limit distinct fortunate numbers
# generated in order of the primoridials
def fortunates($limit):
  label $out
  | foreach primorials as $p ([];
      first( range(3; infinite; 2) | select($p + . | is_prime)) as $q
      | . + [$q] | unique;
      if length >= $limit then ., break $out else empty end);

fortunates(10)
