my @expsum = lazy (2..*).hyper.map( -> $Int {
    my atomicint $miss = 0;
    (2..$Int).map( -> $exp {
        if (my $sum = ($Int ** $exp).comb.sum) > $Int { last if ++⚛$miss > 20 }
        $sum == $Int ?? "$Int^$exp" !! Empty;
    }) || Empty;
});

say "First twenty-five integers that are equal to the digital sum of that integer raised to some power:";
put .join(', ') for @expsum[^25];
say "\nFirst thirty that satisfy that condition in three or more ways:";
put .join(', ') for @expsum.grep({.elems≥3})[^30];
