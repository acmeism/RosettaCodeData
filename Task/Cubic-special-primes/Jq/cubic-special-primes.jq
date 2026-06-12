# Output: an array
def cubic_special_primes:
  . as $N
  | sqrt as $maxidx
  | {cprimes: [2], q: 0}
  | until( .cprimes[-1] >= $N or .q >= $N;
      label $out
      | foreach range(1; $maxidx + 1) as $i (.;
          .q = (.cprimes[-1] + ($i * $i * $i))
          | if .q >= $N
	    then .emit = true
            elif .q | is_prime
            then .cprimes = .cprimes + [.q]
            | .emit = true
            else .
	    end;
	    select(.emit)) | {cprimes, q}, break $out )
  | .cprimes ;	

15000
| ("Cubic special primes < \(.):",
    cubic_special_primes)
