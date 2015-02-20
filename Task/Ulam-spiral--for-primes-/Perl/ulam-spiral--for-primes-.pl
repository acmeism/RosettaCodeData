use ntheory qw/is_prime/;
use Imager;

my $n = shift || 512;
my $start = shift || 1;
my $file = "ulam.png";

sub cell {
  my($n, $x, $y, $start) = @_;
  $y -= $n>>1;
  $x -= ($n-1)>>1;
  my $l = 2*(abs($x) > abs($y) ? abs($x) : abs($y));
  my $d = ($y > $x)  ?  $l*3 + $x + $y  : $l-$x-$y;
  ($l-1)**2 + $d + $start - 1;
}

my $black = Imager::Color->new('#000000');
my $white = Imager::Color->new('#FFFFFF');
my $img = Imager->new(xsize => $n, ysize => $n, channels => 1);
$img->box(filled=>1, color=>$white);

for my $y (0 .. $n-1) {
  for my $x (0 .. $n-1) {
    my $v = cell($n, $x, $y, $start);
    $img->setpixel(x => $x, y => $y, color => $black) if is_prime($v);
  }
}

$img->write(file => $file) or die "Cannot write $file: ", $img->errstr, "\n";
