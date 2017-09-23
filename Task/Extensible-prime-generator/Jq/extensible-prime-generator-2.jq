# Is the input integer a prime?
# "previous" must be the array of sorted primes greater than 1 up to (.|sqrt)
def is_prime(previous):
  . as $in
  | (previous|length) as $plength
  | [false, 0]   # state: [found, ix]
  | until( .[0] or .[1] >= $plength;
           [ ($in % previous[.[1]]) == 0, .[1] + 1] )
  | .[0] | not ;

# extend_primes expects its input to be an array consisting of
# previously found primes, in order, and extends that array:
def extend_primes:
  if . == null or length == 0 then [2]
  else . as $previous
  | if . == [2] then [2,3]
    else . + [(2 + .[length-1]) | until( is_prime($previous) ; . + 2)]
    end
  end;

# If . is an integer > 0 then produce an array of . primes;
# otherwise emit an unbounded stream of primes:
def primes:
  . as $n
  | if type == "number" and $n > 0 then
      null | until( length == $n; extend_primes )
    else [2] | recurse(extend_primes) | .[length - 1]
    end;

# Primes up to and possibly including n:
def primes_upto(n):
  until( .[length-1] > n; extend_primes )
  | if .[length-1] > n then .[0:length-1] else . end;
