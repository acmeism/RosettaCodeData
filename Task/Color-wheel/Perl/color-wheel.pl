use Imager;
use Math::Complex qw(cplx i pi);

my ($width, $height) = (300, 300);
my $center = cplx($width/2, $height/2);

my $img = Imager->new(xsize => $width,
                      ysize => $height);

foreach my $y (0 .. $height - 1) {
    foreach my $x (0 .. $width - 1) {

        my $vec = $center - $x - $y * i;
        my $mag = 2 * abs($vec) / $width;
        my $dir = (pi + atan2($vec->Re, $vec->Im)) / (2 * pi);

        $img->setpixel(x => $x, y => $y,
            color => {hsv => [360 * $dir, $mag, $mag < 1 ? 1 : 0]});
    }
}

$img->write(file => 'color_wheel.png');
