use Imager;
use List::AllUtils qw(sum pairwise);

sub img_diff {
    my ($file1, $file2) = @_;

    my $img1 = Imager->new(file => $file1);
    my $img2 = Imager->new(file => $file2);

    my ($w1, $h1) = ($img1->getwidth, $img1->getheight);
    my ($w2, $h2) = ($img2->getwidth, $img2->getheight);

    if ($w1 != $w2 or $h1 != $h2) {
        die "Can't compare images of different sizes";
    }

    my $sum = 0;
    foreach my $y (0 .. $h1 - 1) {
        foreach my $x (0 .. $w1 - 1) {
            my @rgba1 = $img1->getpixel(x => $x, y => $y)->rgba;
            my @rgba2 = $img2->getpixel(x => $x, y => $y)->rgba;
            $sum += sum(pairwise { abs($a - $b) } @rgba1, @rgba2);
        }
    }

    $sum / ($w1 * $h1 * 255 * 3);
}

printf "difference = %f%%\n", 100 * img_diff('Lenna50.jpg', 'Lenna100.jpg');
