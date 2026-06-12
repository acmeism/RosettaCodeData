# Input: a number > 2
# Output: an array of the quadrat primes less than `.`
def quadrat:
  . as $N
  | ($N|sqrt) as $lastn
  | { qprimes: [2], q: 2 }
  | until ( .qprimes[-1] >= $N or .q >= $N;
        label $out
        | foreach range(1; $lastn + 1) as $i (.;
            .q = .qprimes[-1] + $i * $i
            | if .q >= $N then .emit = true
              elif .q|is_prime then .qprimes = .qprimes + [.q]
              | .emit = true
              else .
	      end;
	    select(.emit)) | {qprimes, q}, break $out )
   | .qprimes ;

"Quadrat special primes < 16000:",
(16000 | quadrat[])
