sub lcs(Str $xstr, Str $ystr) { # longest common subsequence
    return "" unless $xstr && $ystr;
    my ($x, $xs, $y, $ys) = $xstr.substr(0, 1), $xstr.substr(1), $ystr.substr(0, 1), $ystr.substr(1);
    return $x eq $y
        ?? $x ~ lcs($xs, $ys)
        !! max(:by{ $^a.chars }, lcs($xstr, $ys), lcs($xs, $ystr) );
}

sub scs ($u, $v) { # shortest common supersequence
    my @lcs = (lcs $u, $v).comb;
    my $pat = '(.*)' ~ join('(.*)',@lcs) ~ '(.*)';
    my $regex = "rx/$pat/".EVAL;
    my @u = ($u ~~ $regex).list;
    my @v = ($v ~~ $regex).list;
    my $scs = shift(@u) ~ shift(@v);
    $scs ~= $_ ~ shift(@u) ~ shift(@v) for @lcs;
    return $scs;
}

my $u = 'abcbdab';
my $v = 'bdcaba';
printf "Strings: %s %s\n", $u, $v;
printf "Longest common subsequence:   %s\n", lcs $u, $v;
printf "Shortest common supersquence: %s\n", scs $u, $v;
