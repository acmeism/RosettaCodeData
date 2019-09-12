use Image::Imlib2;

my $img1 = Image::Imlib2->load('Lenna50.jpg')  || die;
my $img2 = Image::Imlib2->load('Lenna100.jpg') || die;

my $w = $img1->width;
my $h = $img1->height;

my $sum = 0;

for my $x (0..$w-1) {
    for my $y (0..$h-1) {
        my ($r1, $g1, $b1) = $img1->query_pixel($x, $y);
        my ($r2, $g2, $b2) = $img2->query_pixel($x, $y);
        $sum += abs($r1-$r2) + abs($g1-$g2) + abs($b1-$b2);
    }
}

printf "%% difference = %.4f\n", 100 * $sum / ($w * $h * 3 * 255);
