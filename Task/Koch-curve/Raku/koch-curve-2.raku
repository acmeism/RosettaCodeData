use SVG;

role Lindenmayer {
    has %.rules;
    method succ {
	    self.comb.map( { %!rules{$^c} // $c } ).join but Lindenmayer(%!rules)
    }
}

my $koch = 'F' but Lindenmayer( { F => 'F+F-F-F+F', } );

$koch++ xx 4;
my @points = (450, 250);

for $koch.comb -> $v {
    state ($x, $y) = @points[0,1];
    state $d = -5 - 0i;
    with $v {
        when 'F' { @points.append: ($x += $d.re).round(.01), ($y += $d.im).round(.01) }
        when /< + - >/ { $d *= "{$v}1i" }
    }
}

say SVG.serialize(
    svg => [
        width => 500, height => 300, style => 'stroke:rgb(0,0,255)',
        :rect[:width<100%>, :height<100%>, :fill<white>],
        :polyline[ points => @points.join(','), :fill<white> ],
    ],
);
