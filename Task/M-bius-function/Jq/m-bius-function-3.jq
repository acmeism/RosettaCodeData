# relatively_prime(previous) tests whether the input integer is prime
# relative to the primes in the array "previous":
def relatively_prime(previous):
  . as $in
  | (previous|length) as $plen
  # state: [found, ix]
  | [false, 0]
  | until( .[0] or .[1] >= $plen;
           [ ($in % previous[.[1]]) == 0, .[1] + 1] )
  | .[0] | not ;

# Emit a stream in increasing order of all primes (from 2 onwards)
# that are less than or equal to mx:
def primes(mx):
  # The helper function, next, has arity 0 for tail recursion optimization;
  # it expects its input to be the array of previously found primes:
  def next:
     . as $previous
     | ($previous | .[length-1]) as $last
     | if ($last >= mx) then empty
       else ((2 + $last)
       | until( relatively_prime($previous) ; . + 2)) as $nextp
       | if $nextp <= mx
         then $nextp, (( $previous + [$nextp] ) | next)
	 else empty
         end
       end;
  if mx <= 1 then empty
  elif mx == 2 then 2
  else (2, 3, ([2,3] | next))
  end ;

# Return an array of the distinct prime factors of . in increasing order
def prime_factors:

  # Return an array of prime factors of . given that "primes"
  # is an array of relevant primes:
  def pf($primes):
    if . <= 1 then []
    else . as $in
    | if ($in | relatively_prime($primes)) then [$in]
      else reduce $primes[] as $p
             ([];
              if ($in % $p) != 0 then .
 	      else . + [$p] +  (($in / $p) | pf($primes))
	      end)
      end
      | unique
    end;

  if . <= 1 then []
  else . as $in
  | pf( [ primes( (1+$in) | sqrt | floor)  ] )
  end;
