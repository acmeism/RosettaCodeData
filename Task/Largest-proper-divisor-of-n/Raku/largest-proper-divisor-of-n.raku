use Prime::Factor;

for 0, 2**67 - 1 -> $add {
    my $start = now;

    my $range = $add + 1 .. $add + 100;

    say "GPD for {$range.min} through {$range.max}:";

    say ( $range.hyper(:14batch).map: {$_ == 1 ?? 1 !! $_ %% 2 ?? $_ / 2 !! .&proper-divisors.max} )\
        .batch(10)».fmt("%{$add.chars + 1}d").join: "\n";

    say (now - $start).fmt("%0.3f seconds\n");
}
