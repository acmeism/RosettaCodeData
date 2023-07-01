sub normdist ($m, $σ) {
    my $r = sqrt -2 * log rand;
    my $Θ = τ * rand;
    $r * cos($Θ) * $σ + $m;
}

sub MAIN ($size = 100000, $mean = 50, $stddev = 4) {
    my @dataset = normdist($mean,$stddev) xx $size;

    my $m = [+](@dataset) / $size;
    say (:$m);

    my $σ = sqrt [+](@dataset X** 2) / $size - $m**2;
    say (:$σ);

    (my %hash){.round}++ for @dataset;
    my $scale = 180 * $stddev / $size;
    constant @subbar = < ⎸ ▏ ▎ ▍ ▌ ▋ ▊ ▉ █ >;
    for %hash.keys».Int.minmax(+*) -> $i {
        my $x = (%hash{$i} // 0) * $scale;
        my $full = floor $x;
        my $part = 8 * ($x - $full);
        say $i, "\t", '█' x $full, @subbar[$part];
    }
}
