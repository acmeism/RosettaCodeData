my @primes   = lazy (2,3,*+2 … Inf).grep: { .is-prime };
my @perfects = lazy gather for @primes {
    my $n = 2**$_ - 1;
    take $n * 2**($_ - 1) if $n.is-prime;
}

.put for @perfects[^12];
