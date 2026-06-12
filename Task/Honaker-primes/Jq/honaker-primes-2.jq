# Output: .h gives details for the first $n Honaker primes, and
#         .hmax gives details for the $max-th
def honakers($sieveLength; $n; $max):
  ($sieveLength|primeSieve|map(select(.))) as $primes
  | { i: 1,
      count: 0,
      h: [],
      hmax: null}
  | until(.done or .i > $sieveLength;
      if (.i|digitSum) == ($primes[.i-1] | digitSum)
      then .count += 1
      | if .count <= 50
        then .h += [[.i, $primes[.i-1]]]
        elif .count == $max
        then .hmax = [.i, $primes[.i-1]]
        | .done = true
        else .
	end
      else .
      end
      | .i += 1 );

5e6 as $enough
| "The first 50 Honaker primes [index, prime]:",
  (honakers($enough; 50; 10000)
   | (.h | map( "[\(.[0]|lpad(3)), \(.[1]|lpad(4))]") | _nwise(5) | join("  ")),
     "\nand the 10,000th:",
     .hmax )
