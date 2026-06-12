def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# Primes less than . // infinite
def primes:
  (. // infinite) as $n
  | if $n < 3 then empty
    else 2, (range(3; $n) | select(is_prime))
    end;
