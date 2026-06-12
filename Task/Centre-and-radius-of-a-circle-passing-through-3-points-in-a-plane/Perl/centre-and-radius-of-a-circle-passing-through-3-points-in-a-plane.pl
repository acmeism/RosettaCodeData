# 20240914 Perl programming solution

use strict;
use warnings;

sub circle {
   my ($point1, $point2, $point3) = @_;
   my (($x1, $y1), ($x2, $y2), ($x3, $y3)) = ( @$point1,  @$point2, @$point3);

   my $C_x = ((($x1**2 + $y1**2) * ($y3 - $y2)  +
               ($x2**2 + $y2**2) * ($y1 - $y3)  +
               ($x3**2 + $y3**2) * ($y2 - $y1)) /
               ($x1*($y3 - $y2) + $x2*($y1 - $y3) + $x3*($y2 - $y1)) / 2);

   my $C_y = ((($x1**2 + $y1**2) * ($x3 - $x2)  +
               ($x2**2 + $y2**2) * ($x1 - $x3)  +
               ($x3**2 + $y3**2) * ($x2 - $x1)) /
               ($y1*($x3 - $x2) + $y2*($x1 - $x3) + $y3*($x2 - $x1)) / 2);

   my $radius = sqrt(($C_x - $x1)**2 + ($C_y - $y1)**2);

   return { center => [$C_x, $C_y], radius => $radius };
}

my $result = circle([22.83, 2.07], [14.39, 30.24], [33.65, 17.31]);
print "center => (", join(" ", @{$result->{center}}), ") radius => ", $result->{radius}, "\n";
