use strict;
use warnings;

sub CORDIC {
    my($a) = shift;
    my ($k, $x, $y) = (0, 1, 0);
    my @PoT = (1, 0.1, 0.01, 0.001, 0.0001, 0.00001);
    my @Tbl = <7.853981633e-1 9.966865249e-2 9.999666686e-3 9.999996666e-4 9.999999966e-5 9.999999999e-6 0>;

    while ($a > 1e-5) {
        $k++ while $a < $Tbl[$k];
        $a -= $Tbl[$k];
        ($x,$y) = ($x - $PoT[$k]*$y, $y + $PoT[$k]*$x);
    }
    $x / sqrt($x*$x + $y*$y)
}

print "Angle    CORDIC       Cosine       Error\n";
for my $angle (<-9 0 1.5 6>) {
    my $cordic = CORDIC abs $angle;
    printf "%4.1f %12.8f %12.8f %12.8f\n", $angle, $cordic, cos($angle), cos($angle) - $cordic
}
