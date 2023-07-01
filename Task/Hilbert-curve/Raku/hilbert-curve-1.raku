use SVG;

role Lindenmayer {
    has %.rules;
    method succ {
        self.comb.map( { %!rules{$^c} // $c } ).join but Lindenmayer(%!rules)
    }
}

my $hilbert = 'A' but Lindenmayer( { A => '-BF+AFA+FB-', B => '+AF-BFB-FA+' } );

$hilbert++ xx 7;
my @points = (647, 13);

for $hilbert.comb {
    state ($x, $y) = @points[0,1];
    state $d = -5 - 0i;
    when 'F' { @points.append: ($x += $d.re).round(1), ($y += $d.im).round(1) }
    when /< + - >/ { $d *= "{$_}1i" }
    default { }
}

say SVG.serialize(
    svg => [
        :660width, :660height, :style<stroke:blue>,
        :rect[:width<100%>, :height<100%>, :fill<white>],
        :polyline[ :points(@points.join: ','), :fill<white> ],
    ],
);
