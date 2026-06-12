def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# Output: a stream of primes in range(0;$n)
def primes($n):
  2, (range(3;$n;2) | select(is_prime));

# Output: a stream of primes satisfying the condition
def results($n):
  foreach primes($n) as $p (0;
    . + $p;
    select(is_prime) | $p );

def task($n):
  "Primes 'p' under \($n) for which the sum of primes <= p is also prime:",
  ( [results($n)]
    | (_nwise(7) | map(lpad(4)) | join(" ")),
      "\nFound \(length) such primes." );

task(1000)
