sub div-count (\x) {
    return 2 if x.is-prime;
    +flat (1 .. x.sqrt.floor).map: -> \d {
        unless x % d { my \y = x div d; y == d ?? y !! (y, d) }
    }
}

my $limit = 15;

my $m = 1;
put "First $limit terms of OEIS:A069654";
put (1..$limit).map: -> $n { my $ = $m = first { $n == .&div-count }, $m..Inf };
