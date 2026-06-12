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
  | reduce (2, 1 + (2 * range(1; $s))) as $i (.; erase($i))
;

# Produce a stream of maximal elements in the stream s.
# To emit both the item and item|f, run: maximal_by( s | [., f]; .[1])
def maximals_by(s; f):
  reduce s as $x ({v:null, a:[]};
    ($x|f) as $y
    | if $y == .v then .a += [$x] elif $y > .v then .v = $y | .a = [$x] else . end)
  | .a[];

# Input: the size of the sieve
def primes: primeSieve | map(select(.));

