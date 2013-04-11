my ($width, $height) = (1000,1000); # image dimension
my $scale = 6/10; # branch scale relative to trunk
my $length = 400; # trunk size

say "<?xml version='1.0' encoding='utf-8' standalone='no'?>
<!DOCTYPE svg PUBLIC '-//W3C//DTD SVG 1.1//EN'
'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'>
<svg width='100%' height='100%' version='1.1'
xmlns='http://www.w3.org/2000/svg'>";

tree($width/2, $height, $length, 3*pi/2);

say "</svg>";

multi tree($, $, $length where { $length < 1}, $) {}
multi tree($x, $y, $length, $angle)
{
	my ($x2, $y2) = ( $x + $length * $angle.cos, $y + $length * $angle.sin);
	say "<line x1='$x' y1='$y' x2='$x2' y2='$y2' style='stroke:rgb(0,0,0);stroke-width:1'/>";
	tree($x2, $y2, $length*$scale, $angle + pi/5);
	tree($x2, $y2, $length*$scale, $angle - pi/5);
}
