# Input:  a positive integer
# Output: an array, $a, of length .+1 such that
#         $a[$i] is $i if $i is prime, and false otherwise.
def primeSieve:
  # erase(i) sets .[i*j] to false for integral j > 1
  def erase(i):
    if .[i] then
      reduce (range(2*i; length; i)) as $j (.; .[$j] = false)
    else .
    end;
  (. + 1) as $n
  | (($n|sqrt) / 2) as $s
  | [null, null, range(2; $n)]
  | reduce (2, 1 + (2 * range(1; $s))) as $i (.; erase($i)) ;

def double_twin_primes($n):
  [$n|primeSieve|range(0;length) as $i | select(.[$i]) | $i] as $p
  | range(1; $p|length-3) as $i
  | select( ($p[$i+1] - $p[$i]) == 2 and ($p[$i+2] - $p[$i+1]) == 4 and ($p[$i+3] - $p[$i+2]) == 2 )
  | [$p[$i, $i+1, $i+2, $i+3]] ;


"Double twin primes under 1,000:",
 double_twin_primes(1000)
