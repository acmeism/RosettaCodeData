use strict 'vars';
use warnings;

use PDL;
use PDL::Image2D;

my $image = rpic 'plasma.png';
my $smoothed = med2d $image, ones(3,3), {Boundary => Truncate};
wpic $smoothed, 'plasma_median.png';
