# This method for sieving turns out to be the fastest in jq.
# Input: an array to be sieved.
# Output: if the array length is less then $n then empty, else the sieved array.
def sieve($n):
  if length<$n then empty
  else . as $in
  | reduce range(0;length) as $i ([]; if $i % $n == 0 then . else . + [$in[$i]]  end)
  end;

# Generate a stream of ludic numbers based on sieving range(2; $nmax+1)
def ludic($nmax):
  def l:
    .[0] as $next
    | $next, (sieve($next)|l);
  1, ([range(2; $nmax+1)] | l);

# Output: an array of the first . ludic primes (including 1)
def first_ludic_primes:
  . as $n
  | def l:
      . as $k
      | [ludic(10*$k)] as $a
      | if ($a|length) >= $n then $a[:$n]
        else (10*$k) | l
        end;
   l;

# Output: an array of the ludic numbers less than .
def ludic_primes:
  . as $n
  | def l:
      . as $k
      | [ludic(10*$k)] as $a
      | if $a[-1] >= $n then $a | map(select(. < $n))
        else (10*$k) | l
        end;
   l;

# Output; a stream of triplets of ludic numbers, where each member of the triplet is less than .
def triplets:
  ludic_primes as $primes
  | $primes[] as $p
  | $primes
  | bsearch($p) as $i
  | if $i >= 0
    then $primes[$i+1:]
    | select( bsearch($p+2) >= 0 and
              bsearch($p+6) >= 0)
    | [$p, $p+2, $p+6]
    else empty
    end;


"First 25 ludic primes:", (25|first_ludic_primes),
"\nThere are \(1000|ludic_primes|length) ludic numbers <= 1000",
( "The \n2000th to 2005th ludic primes are:",
 (2005|first_ludic_primes)[2000:]),
( [250 | triplets]
  | "\nThere are \(length) triplets less than 250:",
    .[] )
