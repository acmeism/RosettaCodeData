def count(s): reduce s as $x (0; .+1);

# Is the input integer a prime?
# "previous" should be a sorted array of consecutive primes
# from 2 on that includes the greatest prime less than (.|sqrt)
def is_prime(previous):
  . as $in
  | (($in + 1) | sqrt) as $sqrt
  | first(previous[]
          | if . > $sqrt then 1
            elif 0 == ($in % .) then 0
            else empty
            end) // 1
  | . == 1;

# This assumes . is an array of consecutive primes beginning with [2,3]
def next_prime:
  . as $previous
  | (2 +  .[-1] )
  | until(is_prime($previous); . + 2) ;

# Emit primes from 2 up
def primes:
  # The helper function has arity 0 for TCO
  # It expects its input to be an array of previously found primes, in order:
  def next:
     . as $previous
     | ($previous|next_prime) as $next
     | $next, (($previous + [$next]) | next) ;
  2, 3, ([2,3] | next);
