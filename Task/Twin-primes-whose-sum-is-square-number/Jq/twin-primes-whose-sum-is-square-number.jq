# Input:  a positive integer
# Output: an array, $a, of length .+1 such that
#         $a[$i] is $i if $i is prime, and false otherwise.
def primeSieve:
  # erase(i) sets .[i*j] to false for integral j > 1
  def erase($i):
    if .[$i] then
      reduce (range(2*$i; length; $i)) as $j (.; .[$j] = false)
    else .
    end;
  (. + 1) as $n
  | (($n|sqrt) / 2) as $s
  | [null, null, range(2; $n)]
  | reduce (2, 1 + (2 * range(1; $s))) as $i (.; erase($i)) ;

def issquare: . == (sqrt|trunc | .*.) ;

# The task:
def square_twin_primes($mx):
  ($mx | primeSieve | map(select(.)))
  | . as $primes
  | range(0; length -1) as $i
  | $primes[$i] as $prime
  | select (($primes[$i+1] == $prime + 2) and ((2 * ($prime+1)) | issquare))
  | $prime ;

square_twin_primes(10000000)
