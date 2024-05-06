sub div-count (\x) {
    return 2 if x.is-prime;
    +flat (1 .. x.sqrt.floor).map: -> \d {
        unless x % d { my \y = x div d; y == d ?? y !! (y, d) }
    }
}

my $limit = 20;

my @primes = grep { .is-prime }, 1..*;
@primes[$limit]; # prime the array. SCNR

put "First $limit terms of OEIS:A073916";
put (1..$limit).hyper(:2batch).map: -> $n {
    ($n > 4 and $n.is-prime) ??
    exp($n - 1, @primes[$n - 1]) !!
    do {
        my $i = 0;
        my $iterator = $n %% 2 ?? (1..*) !! (1..*).map: *²;
        $iterator.first: {
            next unless $n == .&div-count;
            next unless ++$i == $n;
            $_
        }
    }
};
