constant ε = (1e0, */2e0 … *+1e0==1e0)[*-1];

sub kahan (*@nums) {
    my $summ = my $c = 0e0;
    for @nums -> $num {
        my $y = $num - $c;
        my $t = $summ + $y;
        $c = ($t - $summ) - $y;
        $summ = $t;
    }
    $summ
}

say 'Epsilon:    ', ε;

say 'Simple sum: ', ((1e0 + ε) - ε).fmt: "%.16f";

say 'Kahan sum:  ', kahan(1e0, ε, -ε).fmt: "%.16f";
