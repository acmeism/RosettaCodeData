use GD::Raw;

my $file = '/tmp/one-pixel-screen-capture.png';

qqx/screencapture -R 123,456,1,1 $file/;

my $fh    = fopen($file, "rb") or die;
my $image = gdImageCreateFromPng($fh);
my $pixel = gdImageGetPixel($image, 0, 0);
my ($red,$green,$blue) =
    gdImageRed(  $image, $pixel),
    gdImageGreen($image, $pixel),
    gdImageBlue( $image, $pixel);

say "RGB: $red, $green, $blue";

fclose($fh);
unlink $file;
