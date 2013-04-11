sub randnorm ($mean, $stddev) {
    $mean + $stddev * sqrt(-2 * log rand) * cos(2 * pi * rand)
}

my @nums = map { randnorm 1, 0.5 }, ^1000;
