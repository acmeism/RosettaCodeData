def is_Erdos:
  . as $p
  | if is_prime|not then false
    else label $out
    | foreach range(1; .+1) as $k (1; . * $k;
        if . >= $p then true, break $out
        elif ($p - .) | is_prime then 0, break $out
	else empty
	end) // true
    | . == true
    end ;	

# emit the Erdos primes
def Erdos: range(2; infinite) | select(is_Erdos);
