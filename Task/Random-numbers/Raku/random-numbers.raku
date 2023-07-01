sub randnorm ($mean, $stddev) {
    $mean + $stddev * sqrt(-2 * log rand) * cos(2 * pi * rand)
}

my @nums = randnorm(1, 0.5) xx 1000;

# Checking
say my $mean = @nums R/ [+] @nums;
say my $stddev = sqrt $mean**2 R- @nums R/ [+] @nums X** 2;
