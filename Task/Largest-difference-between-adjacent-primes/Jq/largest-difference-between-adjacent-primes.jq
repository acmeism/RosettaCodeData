# Primes less than . // infinite
def primes:
  (. // infinite) as $n
  | if $n < 3 then empty
    else 2, (range(3; $n) | select(is_prime))
    end;

def largest_difference_between_adjacent_primes:
  reduce primes as $p ( null;  # [prev, diff]
    if . == null then [$p, 0]
    else ($p - .[0]) as $diff
    | if $diff > .[1] then [$p, $diff]
      else .[0] = $p
      end
    end)
  | .[1];

pow(10; 1, 2, 6) | largest_difference_between_adjacent_primes
