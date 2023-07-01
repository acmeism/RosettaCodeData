use Math::Polynomial::Cyclotomic:from<Perl5> <cyclo_poly_iterate cyclo_poly>;

say 'First 30 cyclotomic polynomials:';
my $iterator = cyclo_poly_iterate(1);
say "Φ($_) = " ~ super $iterator().Str for 1..30;

say "\nSmallest cyclotomic polynomial with |n| as a coefficient:";
say "Φ(1) has a coefficient magnitude: 1";

my $index = 0;
for 2..9 -> $coefficient {
    loop {
        $index += 5;
        my \Φ = cyclo_poly($index);
        next unless Φ ~~ / $coefficient\* /;
        say "Φ($index) has a coefficient magnitude: $coefficient";
        $index -= 5;
        last;
    }
}

sub super ($str) {
    $str.subst( / '^' (\d+) /, { $0.trans([<0123456789>.comb] => [<⁰¹²³⁴⁵⁶⁷⁸⁹>.comb]) }, :g)
}
