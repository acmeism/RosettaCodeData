use Imager;

use constant pi => 3.14159265;

sub hough {
    my($im)     = shift;
    my($width)  = shift || 460;
    my($height) = shift || 360;
    $height = 2 * int $height/2;

    $height = 2 * int $height/2;
    my($xsize, $ysize) = ($im->getwidth, $im->getheight);
    my $ht = Imager->new(xsize => $width, ysize => $height);
    for my $i (0..$height-1) { for my $j (0..$width-1) { $canvas[$i][$j] = 255 } }
    $ht->box(filled => 1, color => 'white');

    $rmax = sqrt($xsize**2 + $ysize**2);
    $dr   = 2 * $rmax / $height;
    $dth  = pi / $width;

    for $x (0..$xsize-1) {
      for $y (0..$ysize-1) {
        my $col = $im->getpixel(x => $x, y => $y);
        my($r,$g,$b) = $col->rgba;
        next if $r==255; # && $g==255 && $b==255;
        for $k (0..$width) {
            $th = $dth*$k;
            $r = ($x*cos($th) + $y*sin($th));
            $iry = ($height/2 + int($r/$dr + 0.5));
            $ht->setpixel(x => $k, y => $iry, color => [ ($canvas[$iry][$k]--) x 3] );
        }
      }
    }
    return $ht;
}

my $img = Imager->new;
$img->read(file => 'ref/pentagon.png') or die "Cannot read: ", $img->errstr;
$ht->write(file => 'hough_transform.png');
