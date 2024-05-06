# Emit [n, nth_with_n_divisors] for n in range(1; .+1)
def nth_with_n_divisors:
  | [limit( .; primes)] as $primes
  | range( 1; 1 + .) as $i
  | if $i | is_prime
    then [$i, ($primes[$i-1]|power($i-1))]
    else {count: 0, j: 1}
    | until(.count == $i ;
        .cont = false
        | if ($i % 2) == 1 then (.j|sqrt|floor) as $sq
          | if ($sq * $sq) != .j then .j += 1 | .cont = true else . end
	  else .
	  end
          | if .cont == false
            then if (.j | count(divisors)) == $i
                 then .count += 1
                 else .
                 end
            | if .count != $i then .j += 1 else . end
            else .
            end )

    | [ $i, .j]
    end;

"The first 33 terms in the sequence are:",
(33 | nth_with_n_divisors)
