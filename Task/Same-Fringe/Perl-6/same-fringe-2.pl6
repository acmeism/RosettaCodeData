my $a = 1 => 2 => 3 => 4 => 5 => 6 => 7 => 8;
my $b = 1 => (( 2 => 3 ) => (4 => (5 => ((6 => 7) => 8))));
my $c = (((1 => 2) => 3) => 4) => 5 => 6 => 7 => 8;

my $x = 1 => 2 => 3 => 4 => 5 => 6 => 7 => 8 => 9;
my $y = 0 => 2 => 3 => 4 => 5 => 6 => 7 => 8;
my $z = 1 => 2 => (4 => 3) => 5 => 6 => 7 => 8;

say  so samefringe $a, $a;
say  so samefringe $a, $b;
say  so samefringe $a, $c;

say not samefringe $a, $x;
say not samefringe $a, $y;
say not samefringe $a, $z;
