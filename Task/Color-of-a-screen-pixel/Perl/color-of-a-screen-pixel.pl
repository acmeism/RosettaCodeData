use strict;
use warnings;
use GD;

my $file = '/tmp/one-pixel-screen-capture.png';

system "screencapture -R 123,456,1,1 $file";

my $image = GD::Image->newFromPng($file);
my $index = $image->getPixel(0,0);
my($red,$green,$blue) = $image->rgb($index);
print "RGB: $red, $green, $blue\n";

unlink $file;
