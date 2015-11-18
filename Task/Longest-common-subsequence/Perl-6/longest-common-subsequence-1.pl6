say lcs("thisisatest", "testing123testing");sub lcs(Str $xstr, Str $ystr) {
    return "" unless $xstr && $ystr;

    my ($x, $xs, $y, $ys) = $xstr.substr(0, 1), $xstr.substr(1), $ystr.substr(0, 1), $ystr.substr(1);
    return $x eq $y
        ?? $x ~ lcs($xs, $ys)
        !! max(:by{ $^a.chars }, lcs($xstr, $ys), lcs($xs, $ystr) );
}

say lcs("thisisatest", "testing123testing");
