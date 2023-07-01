use Image::PNG::Portable;

my ($w, $h) = (640, 640);

my $png = Image::PNG::Portable.new: :width($w), :height($h);

my ($x, $y) = (0, 0);

for ^2e5 {
    my $r = 100.rand;
    ($x, $y) = do given $r {
        when  $r <=  1 { (                     0,              0.16 * $y       ) }
        when  $r <=  8 { ( 0.20 * $x - 0.26 * $y,  0.23 * $x + 0.22 * $y + 1.60) }
        when  $r <= 15 { (-0.15 * $x + 0.28 * $y,  0.26 * $x + 0.24 * $y + 0.44) }
        default        { ( 0.85 * $x + 0.04 * $y, -0.04 * $x + 0.85 * $y + 1.60) }
    };
    $png.set(($w / 2 + $x * 60).Int, ($h - $y * 60).Int, 0, 255, 0);
}

$png.write: 'Barnsley-fern-perl6.png';
