use SVG;

role Lindenmayer {
    has %.rules;
    method succ {
	    self.comb.map( { %!rules{$^c} // $c } ).join but Lindenmayer(%!rules)
    }
}

my $dragon = "FX" but Lindenmayer( { X => 'X+YF+', Y => '-FX-Y' } );

$dragon++ xx ^15;

my @points = 215, 350;

for $dragon.comb {
    state ($x, $y) = @points[0,1];
    state $d = 2 + 0i;
    if /'F'/ { @points.append: ($x += $d.re).round(.1), ($y += $d.im).round(.1) }
    elsif /< + - >/ { $d *= "{$_}1i" }
}

say SVG.serialize(
    svg => [
        :600width, :450height, :style<stroke:rgb(0,0,255)>,
        :rect[:width<100%>, :height<100%>, :fill<white>],
        :polyline[ :points(@points.join: ','), :fill<white> ],
    ],
);
