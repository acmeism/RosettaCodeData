def lpad($len): tostring | ($len - length) as $l | ([range(0;$l)|" "]|join("")) + .;

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
  | reduce (2, 1 + (2 * range(1; $s|floor))) as $i (.; erase($i)) ;

def primes: primeSieve | map(select(.));

# Input: an array
def ellipsis($n):
  if length <= $n then tostring
  else "[" + (.[0:10] | map(tostring) | join(",")) + ", ...]"
  end;

def task($maxSum):
  ($maxSum|primes) as $primes
  | {maxSum: $maxSum,
     descendants: [range(0; 1+$maxSum)|[]]}
  | .ancestors = .descendants
  | reduce $primes[] as $p (.;
      .descendants[$p] += [$p]
      | reduce range(1; .descendants|length - $p) as $s (.;
          .descendants[$s + $p] += (.descendants[$s] | map($p * .) ) ) )
  | reduce ($primes + [4])[] as $p (.; .descendants[$p] |= .[:-1] )
  | .total = 0
  | foreach (range(1; 1 + .maxSum),null) as $s (.;
      if $s == null then .emit= "\nTotal descendants \(.total)"
      else .emit = null
      | .descendants[$s] |= sort
      | .total += (.descendants[$s]|length)
      | .ix=0
      | (.descendants[$s]|length) as $ld
      | until( .ix == $ld;
               .descendants[$s][.ix] as $d
               | if $d > .maxSum then .ix = $ld # early exit
                 else .ancestors[$d] = .ancestors[$s] + [$s]
                 | .ix += 1
		 end )
      | if ($s < 21 or $s == 46 or $s == 74 or $s == .maxSum)
        then .emit = "\($s|lpad(2)): \(.ancestors[$s]|length) ancestor[s]: \(.ancestors[$s]|lpad(18))"
        | (.descendants[$s]|length) as $count
          | .emit += " \($count|lpad(5)) descendant[s]: \(.descendants[$s]|ellipsis(10))"
	else .
	end
      end)
  | select(.emit).emit;

task(99)
