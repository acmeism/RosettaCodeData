use ntheory:from<Perl5> <factor>;

my @Fermats = (^Inf).map: 2 ** 2 ** * + 1;

my $sub = '₀';
say "First 10 Fermat numbers:";
printf "F%s = %s\n", $sub++, $_ for @Fermats[^10];

$sub = '₀';
say "\nFactors of first few Fermat numbers:";
for @Fermats[^9].map( {"$_".&factor} ) -> $f {
    printf "Factors of F%s: %s %s\n", $sub++, $f.join(' '), $f.elems == 1 ?? '- prime' !! ''
}
