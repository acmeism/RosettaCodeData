my @primes = 2, 3, 5, -> $p { ($p+2, $p+4 ... &prime)[*-1] } ... *;
my @isprime = False,False;   # 0 and 1 are not prime by definition
sub prime($i) {
    my \limit = $i.sqrt.floor;
    @isprime[$i] //= so ($i %% none @primes ...^ { $_ > limit })
}

say "$_ is{ "n't" x !prime($_) } prime." for 1 .. 100;
