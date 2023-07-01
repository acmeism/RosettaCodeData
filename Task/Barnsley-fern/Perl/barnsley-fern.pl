use Imager;

my $w = 640;
my $h = 640;

my $img = Imager->new(xsize => $w, ysize => $h, channels => 3);
my $green = Imager::Color->new('#00FF00');

my ($x, $y) = (0, 0);

foreach (1 .. 2e5) {
  my $r = rand(100);
  ($x, $y) = do {
    if    ($r <=  1) { ( 0.00 * $x - 0.00 * $y,  0.00 * $x + 0.16 * $y + 0.00) }
    elsif ($r <=  8) { ( 0.20 * $x - 0.26 * $y,  0.23 * $x + 0.22 * $y + 1.60) }
    elsif ($r <= 15) { (-0.15 * $x + 0.28 * $y,  0.26 * $x + 0.24 * $y + 0.44) }
    else             { ( 0.85 * $x + 0.04 * $y, -0.04 * $x + 0.85 * $y + 1.60) }
  };
  $img->setpixel(x => $w / 2 + $x * 60, y => $y * 60, color => $green);
}

$img->flip(dir => 'v');
$img->write(file => 'barnsleyFern.png');
