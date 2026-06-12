# Generate pi($n) for $n > 0
def pi_primes:
  foreach range(1; infinite) as $i ({n:0, np: 2};  # n counts, np is the next prime
     if $i < .np then .
     elif $i == .np then .n += 1 | .np |= next_prime
     else .
     end;
     .n);

emit_until(. >= 22; pi_primes)
