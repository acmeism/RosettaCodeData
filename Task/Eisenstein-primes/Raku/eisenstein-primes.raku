my \ω = exp 2i × π/3;

sub norm    (@p) { @p[0]² - @p[0]×@p[1] + @p[1]² }
sub display (@p) { (@p[0] + ω×@p[1]).reals».fmt('%+8.4f').join ~ 'i' }

my @E = gather (-10..10 X -10..10).map: -> (\a,\b) {
    take (a,b) if 0 == a|b || a == b ?? (.is-prime and 2 == $_ mod 3 given (a,b)».abs.max) !! norm((a,b)).is-prime
}

(@E.sort: *.&norm).head(100).map(*.&display).batch(4).join("\n").say;
