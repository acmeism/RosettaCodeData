# Generate a stream of reversible primes.
# If . is null the stream is unbounded;
# otherwise only integers less than . are considered.

def reversible_primes:
  def r: tostring|explode|reverse|implode|tonumber;
  (if . == null then infinite else . end) as $n
  | 2, (range(3; $n; 2) | select(is_prime and (r|is_prime)));

"Primes under 500 which are also primes when the digits are reversed:",
 (500 | reversible_primes)
