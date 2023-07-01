sub mtest($bits, $p) {
    my @bits = $bits.base(2).comb;
    loop (my $sq = 1; @bits; $sq %= $p) {
        $sq ×= $sq;
        $sq += $sq if 1 == @bits.shift;
    }
    $sq == 1;
}

for flat 2 .. 60, 929 -> $m {
    next unless is-prime($m);
    my $f = 0;
    my $x = 2**$m - 1;
    my $q;
    for 1..* -> $k {
        $q = 2 × $k × $m + 1;
        next unless $q % 8 == 1|7 or is-prime($q);
        last if $q × $q > $x or $f = mtest($m, $q);
    }

    say $f ?? "M$m = $x\n\t= $q × { $x div $q }"
           !! "M$m = $x is prime";
}
