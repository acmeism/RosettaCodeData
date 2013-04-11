my @primes := 2, 3, 5, -> $p { ($p+2, $p+4 ... &prime)[*-1] } ... *;
my @isprime = False,False;   # 0 and 1 are not prime by definition
sub prime($i) { @isprime[$i] //= ($i %% none @primes ...^ * > $_ given $i.sqrt.floor) }
