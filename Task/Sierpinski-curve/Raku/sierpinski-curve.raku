use SVG;

role Lindenmayer {
    has %.rules;
    method succ {
        self.comb.map( { %!rules{$^c} // $c } ).join but Lindenmayer(%!rules)
    }
}

my $sierpinski = 'F--XF--F--XF' but Lindenmayer( { X => 'XF+G+XF--F--XF+G+X' } );

$sierpinski++ xx 5;

my $dim = 640;
my $scale = 8;
my $dir = pi/4;
my @points = (316, -108);

for $sierpinski.comb {
    state ($x, $y) = @points[0,1];
    state $d = 0;
    when 'F'|'G' { @points.append: ($x += $scale * $d.cos).round(1), ($y += $scale * $d.sin).round(1) }
    when '+' { $d -= $dir }
    when '-' { $d += $dir }
    default { }
}

my $out = './sierpinski-curve-perl6.svg'.IO;

$out.spurt: SVG.serialize(
    svg => [
        :width($dim), :height($dim),
        :rect[:width<100%>, :height<100%>, :fill<black>],
        :polyline[
          :points(@points.join: ','), :fill<black>,
          :transform("rotate(45, 320, 320)"), :style<stroke:#F7DF1E>,
        ],
    ],
);
