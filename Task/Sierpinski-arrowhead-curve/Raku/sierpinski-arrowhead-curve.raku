use SVG;

role Lindenmayer {
    has %.rules;
    method succ {
        self.comb.map( { %!rules{$^c} // $c } ).join but Lindenmayer(%!rules)
    }
}

my $arrow = 'X' but Lindenmayer( { X => 'YF+XF+Y', Y => 'XF-YF-X' } );

$arrow++ xx 7;

my $w = 800;
my $h = ($w * 3**.5 / 2).round(1);

my $scale = 6;
my @points = (400, 15);
my $dir = pi/3;

for $arrow.comb {
    state ($x, $y) = @points[0,1];
    state $d = $dir;
    when 'F' { @points.append: ($x += $scale * $d.cos).round(1), ($y += $scale * $d.sin).round(1) }
    when '+' { $d += $dir }
    when '-' { $d -= $dir }
    default { }
}

my $out = './sierpinski-arrowhead-curve-perl6.svg'.IO;

$out.spurt:  SVG.serialize(
    svg => [
        :width($w), :height($h),
        :rect[:width<100%>, :height<100%>, :fill<black>],
        :polyline[ :points(@points.join: ','), :fill<black>, :style<stroke:#FF4EA9> ],
    ],
);
