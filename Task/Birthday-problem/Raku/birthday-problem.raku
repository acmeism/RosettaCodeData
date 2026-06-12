sub simulation ($c) {
    my $max-trials = 250_000;
    my $min-trials =   5_000;
    my $n = floor 47 * ($c-1.5)**1.5; # OEIS/A050256: 16 86 185 307
    my $N = min $max-trials, max $min-trials, 1000 * sqrt $n;

    loop {
        my $p = $N R/ elems grep { .elems > 0 }, ((grep { $_>=$c }, values bag (^365).roll($n)) xx $N);
        return($n, $p) if $p > 0.5;
        $N = min $max-trials, max $min-trials, floor 1000/(0.5-$p);
        $n++;
   }
}

printf "$_ people in a group of %s share a common birthday. (%.3f)\n", simulation($_) for 2..5;
