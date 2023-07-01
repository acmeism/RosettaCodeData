use SVG;

role Lindenmayer {
    has %.rules;
    method succ {
        self.comb.map( { %!rules{$^c} // $c } ).join but Lindenmayer(%!rules)
    }
}

my $sierpinski = 'X' but Lindenmayer( { X => 'XF-F+F-XF+F+XF-F+F-X' } );

$sierpinski++ xx 5;

my $dim = 600;
my $scale = 6;

my @points = (-80, 298);

for $sierpinski.comb {
    state ($x, $y) = @points[0,1];
    state $d = $scale + 0i;
    when 'F' { @points.append: ($x += $d.re).round(1), ($y += $d.im).round(1) }
    when /< + - >/ { $d *= "{$_}1i" }
    default { }
}

my @t = @points.tail(2).clone;

my $out = './sierpinski-square-curve-perl6.svg'.IO;

$out.spurt: SVG.serialize(
    svg => [
        :width($dim), :height($dim),
        :rect[:width<100%>, :height<100%>, :fill<black>],
        :polyline[
          :points((@points, map {(@t »+=» $_).clone}, ($scale,0), (0,$scale), (-$scale,0)).join: ','),
          :fill<black>, :transform("rotate(45, 300, 300)"), :style<stroke:#61D4FF>,
        ],
        :polyline[
          :points(@points.map( -> $x,$y { $x, $dim - $y + 1 }).join: ','),
          :fill<black>, :transform("rotate(45, 300, 300)"), :style<stroke:#61D4FF>,
        ],
    ],
);
