sub vdc($num, $base = 2) {
    my $n = $num;
    my $vdc = 0;
    my $denom = 1;
    while $n {
        $vdc += $n mod $base / ($denom *= $base);
        $n div= $base;
    }
    $vdc;
}

for 2..5 -> $b {
    say "Base $b";
    say (vdc($_,$b) for ^10).perl;
    say '';
}
