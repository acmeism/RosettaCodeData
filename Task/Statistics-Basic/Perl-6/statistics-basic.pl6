for 100, 1_000, 10_000 -> $N {
    say "size: $N";
    my @data = rand xx $N;
    printf "mean: %f\n", my $mean = $N R/ [+] @data;
    printf "stddev: %f\n", sqrt
    $mean**2 R- $N R/ [+] @data »**» 2;
    printf "%.1f %s\n", .key, '=' x (500 * .value.elems / $N)
        for sort *.key, @data.classify: (10 * *).Int / 10;
    &say;
}
