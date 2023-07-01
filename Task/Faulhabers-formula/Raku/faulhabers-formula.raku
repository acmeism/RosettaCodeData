sub bernoulli_number($n) {

    return 1/2 if $n == 1;
    return 0/1 if $n % 2;

    my @A;
    for 0..$n -> $m {
        @A[$m] = 1 / ($m + 1);
        for $m, $m-1 ... 1 -> $j {
            @A[$j - 1] = $j * (@A[$j - 1] - @A[$j]);
        }
    }

    return @A[0];
}

sub binomial($n, $k) {
    $k == 0 || $n == $k ?? 1 !! binomial($n-1, $k-1) + binomial($n-1, $k);
}

sub faulhaber_s_formula($p) {

    my @formula = gather for 0..$p -> $j {
        take '('
            ~ join('/', (binomial($p+1, $j) * bernoulli_number($j)).Rat.nude)
            ~ ")*n^{$p+1 - $j}";
    }

    my $formula = join(' + ', @formula.grep({!m{'(0/1)*'}}));

    $formula .= subst(rx{ '(1/1)*' }, '', :g);
    $formula .= subst(rx{ '^1'» }, '', :g);

    "1/{$p+1} * ($formula)";
}

for 0..9 -> $p {
    say "f($p) = ", faulhaber_s_formula($p);
}
