def primes:
  # The array we use for the sieve only stores information for the odd integers greater than 1:
  #  index   integer
  #      0         3
  #      k   2*k + 3
  # So if we wish to mark m = 2*k + 3, the relevant index is: m - 3 / 2
  def ix:
    if . % 2 == 0 then null
    else ((. - 3) / 2)
    end;

  # erase(i) sets .[i*j] to false for odd integral j > i, and assumes i is odd
  def erase(i):
    ((i - 3) / 2) as $k
    # Consider relevant multiples:
    then (((length * 2 + 3) / i)) as $upper
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
  | 2, (range(3; $n; 2) | select($sieve[ix]))
  end ;

def count(s): reduce s as $_ (0; .+1);

count(1e6 | primes)
