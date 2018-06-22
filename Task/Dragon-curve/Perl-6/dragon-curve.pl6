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

$dragon++ for ^15;

say "<?xml version='1.0' encoding='utf-8' standalone='no'?>
<!DOCTYPE svg PUBLIC '-//W3C//DTD SVG 1.1//EN'
'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'>
<svg width='800' height='600' version='1.1'
xmlns='http://www.w3.org/2000/svg' transform='translate(222,325)'
style='stroke:rgb(0,0,255);stroke-width:1'>";
say '<rect height="100%" width="100%" style="fill:white;"
transform="translate(-222,-325)"/>';

for $dragon.comb {
    state ($x, $y) = 100, 100;
    state $d = 2 + 0i;

    if /F/ {
	say "<line x1='$x' y1='$y' x2='{$x += $d.re}' y2='{$y += $d.im}' />";
    }
    elsif /< + - >/ { $d *= "{$_}1i" }
}

say "</svg>";
