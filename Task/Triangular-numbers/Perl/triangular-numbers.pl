use v5.36;
use experimental <builtin for_list>;
use Math::AnyNum <binomial cbrt max round>;

sub table { my $t = 6 * (my $c = 1 + length max @_); ( sprintf( ('%'.$c.'d')x@_, @_) ) =~ s/.{1,$t}\K/\n/gr }

sub triangular_root ($x) {
    round( (sqrt(8 * $x + 1) - 1) / 2, -3);
}

sub tetrahedral_root ($x) {
    round(
      cbrt(3 * $x + sqrt 9 * $x**2 - 1/27) +
      cbrt(3 * $x - sqrt 9 * $x**2 - 1/27) - 1,
    -3)
}

sub pentatopic_root ($x) {
    round( (sqrt(5 + 4 * sqrt 24 * $x + 1) - 3) / 2, -3)
}

sub polytopic ($r, @range) { map { binomial $_ + $r - 1, $r } @range }

for my($r,$label) (2, 'triangular', 3, 'tetrahedral', 4, 'pentatopic', 12, '12-simplex') {
    say "First 30 $label numbers:\n" . table polytopic $r, 0..29
}

for (7140, 21408696, 26728085384, 14545501785001) {
    printf "Roots of $_:
   triangular-root: %s
  tetrahedral-root: %s
   pentatopic-root: %s\n\n",
            triangular_root($_), tetrahedral_root($_), pentatopic_root($_);
}
