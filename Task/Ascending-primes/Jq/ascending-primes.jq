# Output: the stream of ascending primes, in order
def ascendingPrimes:
  # Generate the stream of primes beginning with the digit .
  # and with strictly ascending digits, without regard to order
  def generate:
    # strings
    def g:
      . as $first
      | tonumber as $n
      | select($n <= 9)
      | $first,
        ((range($n + 1;10) | tostring | g) as $x
         | $first + $x );
    tostring | g | tonumber | select(is_prime);

  [range(1;10) | generate] | sort[];

def task:
  def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;
  [ascendingPrimes]
  | "There are \(length) ascending primes, namely:",
    ( _nwise(10) | map(lpad(10)) | join(" ") );

task
