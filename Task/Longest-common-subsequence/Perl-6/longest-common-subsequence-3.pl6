sub lcs(Str $xstr, Str $ystr) {
    my ($a,$b) = ([$xstr.comb],[$ystr.comb]);

    my $positions;
    for $a.kv -> $i,$x { $positions{$x} +|= 1 +< $i };

    my $S = +^0;
    my $Vs = [];
    my ($y,$u);
    for (0..+$b-1) -> $j {
        $y = $positions{$b[$j]} // 0;
        $u = $S +& $y;
        $S = ($S + $u) +| ($S - $u);
        $Vs[$j] = $S;
    }

    my ($i,$j) = (+$a-1, +$b-1);
    my $result = "";
    while ($i >= 0 && $j >= 0) {
        if ($Vs[$j] +& (1 +< $i)) { $i-- }
        else {
            unless ($j && +^$Vs[$j-1] +& (1 +< $i)) {
                $result = $a[$i] ~ $result;
                $i--;
            }
            $j--;
        }
    }
    return $result;
}

say lcs("thisisatest", "testing123testing");
