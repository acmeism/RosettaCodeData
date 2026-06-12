use SVG;

role Lindenmayer {
    has %.rules;
    method succ {
	    self.comb.map( { %!rules{$^c} // $c } ).join but Lindenmayer(%!rules)
    }
}

my $penrose = '[N]++[N]++[N]++[N]++[N]' but Lindenmayer(
    {
        A => '',
        M => 'OA++PA----NA[-OA----MA]++',
        N => '+OA--PA[---MA--NA]+',
        O => '-MA++NA[+++OA++PA]-',
        P => '--OA++++MA[+PA++++NA]--NA'
    }
);

$penrose++ xx 4;

my @lines;
my @stack;

for $penrose.comb {
    state ($x, $y) = 300, 200;
    state $d = 55 + 0i;
    when 'A' { @lines.push: 'line' => [:x1($x.round(.01)), :y1($y.round(.01)), :x2(($x += $d.re).round(.01)), :y2(($y += $d.im).round(.01))] }
    when '[' { @stack.push: ($x.clone, $y.clone, $d.clone) }
    when ']' { ($x, $y, $d) = @stack.pop }
    when '+' { $d *= cis -π/5 }
    when '-' { $d *= cis  π/5 }
    default { }
}

say SVG.serialize(
    svg => [
        :600width, :400height, :style<stroke:rgb(250,12,210)>,
        :rect[:width<100%>, :height<100%>, :fill<black>],
        |@lines,
    ],
);
