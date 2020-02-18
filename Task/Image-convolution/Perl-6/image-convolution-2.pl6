# Note: must install version from github NOT version from CPAN which needs to be updated.
# Reference:
# https://github.com/azawawi/perl6-magickwand
# http://www.imagemagick.org/Usage/convolve/

use v6;

use MagickWand;

# A new magic wand
my $original = MagickWand.new;

# Read an image
$original.read("./Lenna100.jpg") or die;

my $o = $original.clone;

# using coefficients from kernel "Sobel"
# http://www.imagemagick.org/Usage/convolve/#sobel
$o.convolve( [ 1, 0, -1,
               2, 0, -2,
               1, 0, -1] );

$o.write("Lenna100-convoluted.jpg") or die;

# And cleanup on exit
LEAVE {
  $original.cleanup   if $original.defined;
  $o.cleanup if $o.defined;
}
