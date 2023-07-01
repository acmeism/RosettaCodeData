use Imager;

my($xsize,$ysize) = (640,400);
$img = Imager->new(xsize => $xsize, ysize => $ysize);

my $eps = 10**-14;
my $height = int $ysize / 4;
for my $width (1..4) {
    $stripes = int((1-$eps) + $xsize / $width / 2);
    @row = ((0) x $width, (1) x $width) x $stripes;
    for $x (0..$#row) {
        for $y (0..$height) {
            my $offset = $height*($width-1);
            $img->setpixel(x => $x, y => $y+$offset, color => $row[$x] ? 'black' : 'white')
        }
    }
}

$img->write(file => 'pinstripes-bw.png');
