use Math::Root:ver<0.0.4>;

sub binomial { [×] ($^n … 0) Z/ 1 .. $^p }

sub polytopic (Int $r, @range) { @range.map: { binomial $_ + $r - 1, $r } }

sub display (@values) {
    my $c = @values.max.chars;
    @values.batch(6)».fmt("%{$c}d").join: "\n";
}

for 2, 'triangular', 3, 'tetrahedral', 4, 'pentatopic', 12, '12-simplex'
  -> $r, $name { say "\nFirst 30 $name numbers:\n" ~ display polytopic $r, ^30 }

say '';

my \ε = FatRat.new: 1, 10**24;

for 7140, 21408696, 26728085384, 14545501785001 {
  say qq:to/R/;
  Roots of $_:
    triangular-root: {.&triangular-root.round:  ε}
   tetrahedral-root: {.&tetrahedral-root.round: ε}
    pentatopic-root: {.&pentatopic-root.round:  ε}
  R
}
