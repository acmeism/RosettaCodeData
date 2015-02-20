use strict;
use warnings;
use Math::BigFloat;

Math::BigFloat->div_scale(100);

my $a = my $n = 1;
my $g = 1 / sqrt(Math::BigFloat->new(2));
my $z = 0.25;
for( 0 .. 17 ) {
	my $x = [ ($a + $g) * 0.5, sqrt($a * $g) ];
	my $var = $x->[0] - $a;
	$z -= $var * $var * $n;
	$n += $n;
	($a, $g) = @$x;
}
print $a * $a / $z, "\n";
