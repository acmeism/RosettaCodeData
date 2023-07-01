# For streams of strings or of arrays or of numbers:
def add(s): reduce s as $x (null; .+$x);

# Primes less than . // infinite
def primes:
  (. // infinite) as $n
  | if $n < 3 then empty
    else 2, (range(3; $n) | select(is_prime))
    end;
