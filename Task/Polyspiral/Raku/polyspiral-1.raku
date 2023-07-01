use SVG;
my $w = 600;
my $h = 600;

for 3..33  -> $a {
    my $angle = $a/τ;
    my $x1 = $w/2;
    my $y1 = $h/2;
    my @lines;

    for 1..144 {
        my $length = 3 * $_;
        my ($x2, $y2) = ($x1, $y1) «+« |cis($angle * $_).reals».round(.01) »*» $length ;
        @lines.push: 'line' => [:x1($x1.clone), :y1($y1.clone), :x2($x2.clone), :y2($y2.clone),
                                :style("stroke:rgb({hsv2rgb(($_*5 % 360)/360,1,1).join: ','})")];
        ($x1, $y1) = $x2, $y2;
    }

    my $fname = "./polyspiral-perl6.svg".IO.open(:w);
    $fname.say( SVG.serialize(
        svg => [
            width => $w, height => $h, style => 'stroke:rgb(0,0,0)',
            :rect[:width<100%>, :height<100%>, :fill<black>],
            |@lines,
        ],)
    );
    $fname.close;
    sleep .15;
}

sub hsv2rgb ( $h, $s, $v ){ # inputs normalized 0-1
    my $c = $v * $s;
    my $x = $c * (1 - abs( (($h*6) % 2) - 1 ) );
    my $m = $v - $c;
    my ($r, $g, $b) = do given $h {
        when   0..^(1/6) { $c, $x, 0 }
        when 1/6..^(1/3) { $x, $c, 0 }
        when 1/3..^(1/2) { 0, $c, $x }
        when 1/2..^(2/3) { 0, $x, $c }
        when 2/3..^(5/6) { $x, 0, $c }
        when 5/6..1      { $c, 0, $x }
    }
    ( $r, $g, $b ).map: ((*+$m) * 255).Int
}
