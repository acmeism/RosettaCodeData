# Output: a stream of primes less than $n in increasing order
def primes($n):
  2, (range(3; $n; 2) | select(is_prime));

# lcm of 1 to $n inclusive
def lcm:
  . as $n
  | reduce primes($n) as $p (1;
      . * ($p | until(. * $p > $n; . * $p)) ) ;

"N: LCM of the numbers 1 to N inclusive",
 ( 10, 20, 200, 2000
   | "\(.): \(smallest_multiple)" )
