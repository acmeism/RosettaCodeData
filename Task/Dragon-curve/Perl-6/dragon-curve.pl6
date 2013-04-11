say "<?xml version='1.0' encoding='utf-8' standalone='no'?>
<!DOCTYPE svg PUBLIC '-//W3C//DTD SVG 1.1//EN'
'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'>
<svg width='100%' height='100%' version='1.1'
xmlns='http://www.w3.org/2000/svg'>";

my $order = 10; # akin to number of recursion steps
my $d_size = 1000; # size in pixels
my $turn_angle = pi/2; # turn angle of each segment, 90 degrees for the canonical dragon

my $angle = pi - ($order * (pi/4)); # starting angle
my $len = ($d_size/1.5) / sqrt(2)**$order; # size of each segment
my ($x, $y) = ($d_size*5/6, $d_size*1/3); # starting point

for 0..2**$order-1 -> $i
{
	# find which side to turn based on the iteration
	$angle += ((($i +& -$i) +< 1) +& $i) ?? -$turn_angle !! $turn_angle;

	my ($dx, $dy) = ($x + $len * $angle.sin, $y - $len * $angle.cos);
	say "<line x1='$x' y1='$y' x2='$dx' y2='$dy' style='stroke:rgb(0,0,0);stroke-width:1'/>";
	($x, $y) = ($dx, $dy);
}

say "</svg>";
