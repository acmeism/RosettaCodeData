use SVG;

role Lindenmayer {
    has %.rules;
    method succ {
        self.comb.map( { %!rules{$^c} // $c } ).join but Lindenmayer(%!rules)
    }
}

my $peano = 'L' but Lindenmayer( { 'L' => 'LFRFL-F-RFLFR+F+LFRFL', 'R' => 'RFLFR+F+LFRFL-F-RFLFR' } );

$peano++ xx 4;
my @points = (10, 10);

for $peano.comb {
    state ($x, $y) = @points[0,1];
    state $d = 0 + 8i;
    when 'F' { @points.append: ($x += $d.re).round(1), ($y += $d.im).round(1) }
    when /< + - >/ { $d *= "{$_}1i" }
    default { }
}

say SVG.serialize(
    svg => [
        :660width, :660height, :style<stroke:lime>,
        :rect[:width<100%>, :height<100%>, :fill<black>],
        :polyline[ :points(@points.join: ','), :fill<black> ],
    ],
);
