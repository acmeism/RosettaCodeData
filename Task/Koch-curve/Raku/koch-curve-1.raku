use SVG;

role Lindenmayer {
    has %.rules;
    method succ {
        self.comb.map( { %!rules{$^c} // $c } ).join but Lindenmayer(%!rules)
    }
}

my $flake = 'F--F--F' but Lindenmayer( { F => 'F+F--F+F' } );

$flake++ xx 5;
my @points = (50, 440);

for $flake.comb -> $v {
    state ($x, $y) = @points[0,1];
    state $d = 2 + 0i;
    with $v {
        when 'F' { @points.append: ($x += $d.re).round(.01), ($y += $d.im).round(.01) }
        when '+' { $d *= .5 + .8660254i }
        when '-' { $d *= .5 - .8660254i }
    }
}

say SVG.serialize(
    svg => [
        width => 600, height => 600, style => 'stroke:rgb(0,0,255)',
        :rect[:width<100%>, :height<100%>, :fill<white>],
        :polyline[ points => @points.join(','), :fill<white> ],
    ],
);
