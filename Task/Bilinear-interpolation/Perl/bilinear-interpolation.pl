use strict;
use warnings;

use GD;

my $image = GD::Image->newFromPng('color_wheel.png');
$image->interpolationMethod( ['GD_BILINEAR_FIXED'] );
my($width,$height) = $image->getBounds();
my $image2 = $image->copyScaleInterpolated( 1.6*$width, 1.6*$height );

$image2->_file('color_wheel_interpolated.png');
