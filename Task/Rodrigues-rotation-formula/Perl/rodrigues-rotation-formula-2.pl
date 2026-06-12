use strict;
use warnings;
use feature <say signatures>;
no warnings 'experimental::signatures';

use Math::Trig;
use List::Util 'sum';
use constant PI => 2 * atan2(1, 0);

sub norm       ($v)       { sqrt sum map { $_*$_ } @$v }
sub normalize  ($v)       { [ map { $_ / norm $v } @$v ] }
sub dotProduct ($v1, $v2) { sum map { $v1->[$_] * $v2->[$_] } 0..$#$v1 }
sub getAngle   ($v1, $v2) { 180/PI * acos dotProduct($v1, $v2) / (norm($v1)*norm($v2)) }
sub mvMultiply ($m,  $v)  { [ map { dotProduct($_, $v) } @$m ] }
sub crossProduct ($v1, $v2) {
    [$v1->[1]*$v2->[2] - $v1->[2]*$v2->[1], $v1->[2]*$v2->[0] - $v1->[0]*$v2->[2], $v1->[0]*$v2->[1] - $v1->[1]*$v2->[0]]
}

sub aRotate ( $p, $v, $a ) {
    my $ca = cos $a/180*PI;
    my $sa = sin $a/180*PI;
    my $t = 1 - $ca;
    my($x,$y,$z) = @$v;
    my $r = [
        [     $ca + $x*$x*$t, $x*$y*$t -   $z*$sa, $x*$z*$t +   $y*$sa],
        [$x*$y*$t +   $z*$sa,      $ca + $y*$y*$t, $y*$z*$t -   $x*$sa],
        [$z*$x*$t -   $y*$sa, $z*$y*$t +   $x*$sa,      $ca + $z*$z*$t]
    ];
    mvMultiply($r, $p)
}

my($v1,$v2) = ([5, -6, 4], [8, 5, -30]);
say join ' ', @{aRotate $v1, normalize(crossProduct $v1, $v2), getAngle $v1, $v2};
