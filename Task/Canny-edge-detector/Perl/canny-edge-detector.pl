# 20220120 Perl programming solution

use strict;
use warnings;

use lib '/home/hkdtam/lib';
use Image::EdgeDetect;

my $detector = Image::EdgeDetect->new();
$detector->process('./input.jpg', './output.jpg') or die; # na.cx/i/pHYdUrV.jpg
