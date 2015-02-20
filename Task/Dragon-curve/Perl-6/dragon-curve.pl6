role Lindenmayer {
    has %.rules;
    method succ {
	self.comb.map(
	    { %!rules{$^c} // $c }
	).join but Lindenmayer(%!rules)
    }
}

my $dragon = "FX" but Lindenmayer(
    { X => 'X+YF+', Y => '-FX-Y' }
);

$dragon++ for ^10;

say "<?xml version='1.0' encoding='utf-8' standalone='no'?>
<!DOCTYPE svg PUBLIC '-//W3C//DTD SVG 1.1//EN'
'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'>
<svg width='100%' height='100%' version='1.1'
xmlns='http://www.w3.org/2000/svg'>";

for $dragon.comb {
    state ($x, $y) = 100, 100;
    state $d = 2 + 0i;

    if /F/ {
	say "<line x1='$x' y1='$y' x2='{$x += $d.re}' y2='{$y += $d.im}' style='stroke:rgb(0,0,0);stroke-width:1'/>";
    }
    elsif /< + - >/ { $d *= "{$_}1i" }
}

say "</svg>";
