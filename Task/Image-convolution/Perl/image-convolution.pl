use strict;
use warnings;

use PDL;
use PDL::Image2D;

my $kernel = pdl [[-2, -1, 0],[-1, 1, 1], [0, 1, 2]]; # emboss

my $image = rpic 'pythagoras_tree.png';
my $smoothed = conv2d $image, $kernel, {Boundary => 'Truncate'};
wpic $smoothed, 'pythagoras_convolution.png';
