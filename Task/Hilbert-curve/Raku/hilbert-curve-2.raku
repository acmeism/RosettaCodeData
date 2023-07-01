use SVG;

role Lindenmayer {
    has %.rules;
    method succ {
        self.comb.map( { %!rules{$^c} // $c } ).join but Lindenmayer(%!rules)
    }
}

my $moore = 'AFA+F+AFA' but Lindenmayer( { A => '-BF+AFA+FB-', B => '+AF-BFB-FA+' } );

$moore++ xx 6;
my @points = (327, 647);

for $moore.comb {
    state ($x, $y) = @points[0,1];
    state $d = 0 - 5i;
    when 'F' { @points.append: ($x += $d.re).round(1), ($y += $d.im).round(1) }
    when /< + - >/ { $d *= "{$_}1i" }
    default { }
}

say SVG.serialize(
    svg => [
        :660width, :660height, :style<stroke:darkviolet>,
        :rect[:width<100%>, :height<100%>, :fill<white>],
        :polyline[ :points(@points.join: ','), :fill<white> ],
    ],
);
