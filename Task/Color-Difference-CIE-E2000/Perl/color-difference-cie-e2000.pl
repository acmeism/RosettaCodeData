use strict;
use warnings;
use Math::Trig qw(pi);

# The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
sub ciede_2000 {
	# Michel Leonard uses Perl with the CIEDE2000 color-difference formula.
	# k_l, k_c, k_h are parametric factors to be adjusted according to
	# different viewing parameters such as textures, backgrounds...
	my ($l_1, $a_1, $b_1, $l_2, $a_2, $b_2) = @_;
	my ($k_l, $k_c, $k_h) = (1.0, 1.0, 1.0);
	my $n = (sqrt($a_1 * $a_1 + $b_1 * $b_1) + sqrt($a_2 * $a_2 + $b_2 * $b_2)) * 0.5;
	$n = $n * $n * $n * $n * $n * $n * $n;
	# GitHub Project :
	# https://github.com/michel-leonard/ciede2000-color-matching
	$n = 1.0 + 0.5 * (1.0 - sqrt($n / ($n + 6103515625.0)));
	my $c_1 = sqrt($a_1 * $a_1 * $n * $n + $b_1 * $b_1);
	my $c_2 = sqrt($a_2 * $a_2 * $n * $n + $b_2 * $b_2);
	# atan2 is preferred over atan because it accurately computes the angle of
	# a point (x, y) in all quadrants, handling the signs of both coordinates.
	my $h_1 = atan2($b_1, $a_1 * $n);
	my $h_2 = atan2($b_2, $a_2 * $n);
	$h_1 += 2.0 * pi if $h_1 < 0.0;
	$h_2 += 2.0 * pi if $h_2 < 0.0;
	$n = abs($h_2 - $h_1);
	# Cross-implementation consistent rounding.
	$n = pi if pi - 1E-14 < $n && $n < pi + 1E-14;
	# When the hue angles lie in different quadrants, the straightforward
	# average can produce a mean that incorrectly suggests a hue angle in
	# the wrong quadrant, the next lines handle this issue.
	my $h_m = ($h_1 + $h_2) * 0.5;
	my $h_d = ($h_2 - $h_1) * 0.5;
	if (pi < $n) {
		$h_d += (0.0 < $h_d) ? -pi : pi;
		$h_m += pi;
	}
	my $p = 36.0 * $h_m - 55.0 * pi;
	$n = ($c_1 + $c_2) * 0.5;
	$n = $n * $n * $n * $n * $n * $n * $n;
	# The hue rotation correction term is designed to account for the
	# non-linear behavior of hue differences in the blue region.
	my $r_t = -2.0 * sqrt($n / ($n + 6103515625.0))
			* sin(pi / 3.0 * exp($p * $p / (-25.0 * pi * pi)));
	$n = ($l_1 + $l_2) * 0.5;
	$n = ($n - 50.0) * ($n - 50.0);
	# Lightness.
	my $l = ($l_2 - $l_1) / ($k_l * (1.0 + 0.015 * $n / sqrt(20.0 + $n)));
	# These coefficients adjust the impact of different harmonic
	# components on the hue difference calculation.
	my $t = 1.0	+ 0.24 * sin(2.0 * $h_m + pi * 0.5)
			+ 0.32 * sin(3.0 * $h_m + 8.0 * pi / 15.0)
			- 0.17 * sin($h_m + pi / 3.0)
			- 0.20 * sin(4.0 * $h_m + 3.0 * pi / 20.0);
	$n = $c_1 + $c_2;
	# Hue.
	my $h = 2.0 * sqrt($c_1 * $c_2) * sin($h_d) / ($k_h * (1.0 + 0.0075 * $n * $t));
	# Chroma.
	my $c = ($c_2 - $c_1) / ($k_c * (1.0 + 0.0225 * $n));
	# Returning the square root ensures that the result represents
	# the "true" geometric distance in the color space.
	return sqrt($l * $l + $h * $h + $c * $c + $c * $h * $r_t);
}

my @tests = (
	[ 73.0,   49.0,   39.4, 73.0,   49.0,   39.4 ],
	[ 30.0,  -41.0, -119.1, 30.0,  -41.0, -119.0 ],
	[ 79.0, -117.0, -100.4, 79.5, -117.0, -100.0 ],
	[ 15.0,  -55.0,    6.7, 14.0,  -55.0,    7.0 ],
	[ 83.0,   98.0,  -59.5, 85.2,   98.0,  -59.5 ],
	[ 59.0,  -11.0,  -95.0, 56.3,  -11.0,  -95.0 ],
	[ 74.0,   -1.0,   68.6, 81.0,   -1.0,   69.0 ],
	[ 46.4,  125.0,    6.0, 40.0,  125.0,    6.0 ],
	[ 18.0,   -5.0,   68.0, 20.0,    5.0,   82.0 ],
	[ 35.5,  -99.0,  109.0, 25.0,  -99.0,  109.0 ],
	[ 59.0,   77.0,   41.5, 63.3,   77.0,   12.4 ],
	[ 40.0,  -92.0,    7.7, 58.0,  -92.0,   -8.0 ],
	[ 49.0,   -9.0,  -74.5, 51.1,   31.0,   16.0 ],
	[ 88.0, -124.0,   56.0, 97.0,   62.0,  -28.0 ],
	[ 98.0,   75.7,   11.0,  3.0,  -62.0,   11.0 ],
);

print "   L1 	    a1 	    b1     L2     a2 	  b2       ΔE2000\n";
print "------------------------------------------------------------\n";
foreach my $test (@tests) {
	printf("%.1f %10.1f %7.1f %6.1f %6.1f %7.1f %14.10f\n", $test->[0], $test->[1], $test->[2], $test->[3], $test->[4], $test->[5], ciede_2000(@$test));
}

