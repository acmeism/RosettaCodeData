sub hero($a, $b, $c) {
    my $s = ($a + $b + $c) / 2;
    ($s * ($s - $a) * ($s - $b) * ($s - $c)).sqrt;
}

sub heronian-area($a, $b, $c) {
    $_ when Int given hero($a, $b, $c).narrow;
}

sub primitive-heronian-area($a, $b, $c) {
    heronian-area $a, $b, $c
        if 1 == [gcd] $a, $b, $c;
}

sub show(@measures) {
    say "   Area Perimeter   Sides";
    for @measures -> [$area, $perim, $c, $b, $a] {
	printf "%6d %6d %12s\n", $area, $perim, "$a×$b×$c";
    }
}

sub MAIN ($maxside = 200, $first = 10, $witharea = 210) {
    my @hh[1000];
    my atomicint $i;
    (1 .. $maxside).race(:12batch).map: -> $c {
        for 1 .. $c -> $b {
            for $c - $b + 1 .. $b -> $a {
                if primitive-heronian-area($a,$b,$c) -> $area {
                    @hh[$i⚛++] = [$area, $a+$b+$c, $c, $b, $a];
                }
            }
        }
    }

    my @h = (@hh.grep: so *).sort;
    say "Primitive Heronian triangles with sides up to $maxside: ", +@h;

    say "\nFirst $first:";
    show @h[^$first];

    say "\nArea $witharea:";
    show @h.grep: *[0] == $witharea;
}
