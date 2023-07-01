use strict;
use warnings;
use Math::AnyNum 'sqr';

my $a1 = 1.0;
my $a2 = 0.0;
my $d1 = 3.2;

print " i         δ\n";

for my $i (2..13) {
    my $a = $a1 + ($a1 - $a2)/$d1;
    for (1..10) {
        my $x = 0;
        my $y = 0;
        for (1 .. 2**$i) {
            $y = 1 - 2 * $y * $x;
            $x = $a - sqr($x);
        }
        $a -= $x/$y;
    }

    $d1 = ($a1 - $a2) / ($a - $a1);
    ($a2, $a1) = ($a1, $a);
    printf "%2d %17.14f\n", $i, $d1;
}
