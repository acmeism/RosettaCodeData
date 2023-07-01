use Math::Cartesian::Product;

@scoring = (0, 1, 3);
push @histo, [(0) x 10] for 1..4;
push @aoa,    [(0,1,2)] for 1..6;

for $results (cartesian {@_} @aoa) {
    my @s;
    my @g = ([0,1],[0,2],[0,3],[1,2],[1,3],[2,3]);
    for (0..$#g) {
        $r = $results->[$_];
        $s[$g[$_][0]] += $scoring[$r];
        $s[$g[$_][1]] += $scoring[2 - $r];
    }

    my @ss = sort @s;
    $histo[$_][$ss[$_]]++ for 0..$#s;
}

$fmt = ('%3d ') x 10 . "\n";
printf $fmt, @$_ for reverse @histo;
