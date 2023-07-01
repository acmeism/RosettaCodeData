use Imager;

sub plasma {
    my ($w, $h) = @_;

    my $img = Imager->new(xsize => $w, ysize => $h);

    for my $x (0 .. $w-1) {
        for my $y (0 .. $h-1) {
            my $hue = 4 + sin($x/19) + sin($y/9) + sin(($x+$y)/25) + sin(sqrt($x**2 + $y**2)/8);
            $img->setpixel(x => $x, y => $y, color => {hsv => [360 * $hue / 8, 1, 1]});
        }
    }

    return $img;
}

my $img = plasma(400, 400);
$img->write(file => 'plasma-perl.png');
