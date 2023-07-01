sub lcs(Str $xstr, Str $ystr) {
    my (@a, @b) := ($xstr, $ystr)».comb;
    my (%positions, @Vs, $lcs);

    for @a.kv -> $i, $x { %positions{$x} +|= 1 +< ($i % @a) }

    my $S = +^ 0;
    for (0 ..^ @b) -> $j {
        my $u = $S +& (%positions{@b[$j]} // 0);
        @Vs[$j] = $S = ($S + $u) +| ($S - $u)
    }

    my ($i, $j) = @a-1, @b-1;
    while ($i ≥ 0 and $j ≥ 0) {
        unless (@Vs[$j] +& (1 +< $i)) {
            $lcs [R~]= @a[$i] unless $j and ^@Vs[$j-1] +& (1 +< $i);
            $j--
        }
        $i--
    }
    $lcs
}

say lcs("thisisatest", "testing123testing");
