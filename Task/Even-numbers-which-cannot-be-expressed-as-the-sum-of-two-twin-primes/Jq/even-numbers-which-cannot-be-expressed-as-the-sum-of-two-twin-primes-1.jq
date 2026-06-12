# Produce a stream of primes <= .
def eratosthenes:
  # The array we use for the sieve only stores information for the odd integers greater than 1:
  #  index   integer
  #      0         3
  #      k   2*k + 3
  # So if we wish to mark m = 2*k + 3, the relevant index is: m - 3 / 2
  def ix:
    if . % 2 == 0 then null
    else ((. - 3) / 2)
    end;

  # erase(i) sets .[i*j] to false for odd integral j > i on the assumption that i is odd
  def erase(i):
    ((i - 3) / 2) as $k
    | (((length * 2 + 3) / i)) as $upper
    # ... only consider odd multiples from i onwards
    | reduce range(i; $upper; 2) as $j (.;
         (((i * $j) - 3) / 2) as $m
         | if .[$m] then .[$m] = false else . end);

  if . < 2 then []
  else (. + 1) as $n
  | (($n|sqrt) / 2) as $s
  | [range(3; $n; 2)|true]
  | reduce (1 + (2 * range(1; $s)) ) as $i (.; erase($i))
  | . as $sieve
  # We could at this point produce an array of primes by writing:
  # | [2] + reduce range(3; $n; 2) as $k ([]; if $sieve[$k|ix] then . + [$k] else . end)
  | 2, (range(3; $n; 2) | select($sieve[ix]))
  end ;

# Emit an array of the primes <= $limit that have twins
def twins($limit):
  # exclude 2 and 3
  ($limit | [eratosthenes][2:]) as $primes
  | reduce range(0;$primes|length-1) as $i ([3];
      if ($primes[$i+1] - $primes[$i] == 2)
      then if (.[-1] != $primes[$i]) then . + [$primes[$i]] else . end
      | . + [$primes[$i+1]]
      else .
      end);

# Emit an array
def nonTwinSums($limit; $twins):
  reduce range(0; $twins|length) as $i (
       { sieve: [range(0; $limit+1) | false] };
       .emit = null
       | .j = $i
       | until(.emit;
           ($twins[$i] + $twins[.j]) as $sum
           | if $sum > $limit then .emit = .sieve
             else .sieve[$sum] = true
	     end
	   | .j += 1
	   | if .j == ($twins|length) then .emit = .sieve else . end )
     )
  | .sieve as $sieve
  | reduce range(2; $limit + 1; 2) as $i ([];
        if ($sieve[$i] | not) then . + [ $i ] else . end) ;
