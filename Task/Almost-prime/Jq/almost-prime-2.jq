def isalmostprime(k): (prime_factors_with_multiplicities | length) == k;

# Emit a stream of the first N almost-k primes
def almostprimes(N; k):
  if N <= 0 then empty
  else
    # state [remaining, candidate, answer]
    [N, 1, null]
    | recurse( if .[0] <= 0 then empty
	       elif (.[1] | isalmostprime(k)) then [.[0]-1, .[1]+1, .[1]]
	       else [.[0], .[1]+1, null]
               end)
    | .[2] | select(. != null)
  end;
