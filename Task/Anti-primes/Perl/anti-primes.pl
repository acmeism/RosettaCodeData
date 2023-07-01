use ntheory qw(divisors);

my @anti_primes;

for (my ($k, $m) = (1, 0) ; @anti_primes < 20 ; ++$k) {
    my $sigma0 = divisors($k);

    if ($sigma0 > $m) {
        $m = $sigma0;
        push @anti_primes, $k;
    }
}

printf("%s\n", join(' ', @anti_primes));
