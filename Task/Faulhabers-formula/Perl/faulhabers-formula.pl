use 5.014;
use Math::Algebra::Symbols;

sub bernoulli_number {
    my ($n) = @_;

    return 0 if $n > 1 && $n % 2;

    my @A;
    for my $m (0 .. $n) {
        $A[$m] = symbols(1) / ($m + 1);

        for (my $j = $m ; $j > 0 ; $j--) {
            $A[$j - 1] = $j * ($A[$j - 1] - $A[$j]);
        }
    }

    return $A[0];
}

sub binomial {
    my ($n, $k) = @_;
    return 1 if $k == 0 || $n == $k;
    binomial($n - 1, $k - 1) + binomial($n - 1, $k);
}

sub faulhaber_s_formula {
    my ($p) = @_;

    my $formula = 0;
    for my $j (0 .. $p) {
        $formula += binomial($p + 1, $j)
                 *  bernoulli_number($j)
                 *  symbols('n')**($p + 1 - $j);
    }

    (symbols(1) / ($p + 1) * $formula)
        =~ s/\$n/n/gr =~ s/\*\*/^/gr =~ s/\*/ /gr;
}

foreach my $i (0 .. 9) {
    say "$i: ", faulhaber_s_formula($i);
}
