my $S = 10;

my @fixed;

sub allocmesh ($w, $h) {
    gather for ^$h {
	take [0 xx $w];
    }
}

sub force-fixed(@f) {
    @f[1][1] =  1;
    @f[6][7] = -1;
}

sub force-v(@v) {
    @v[1][1] =  1;
    @v[6][7] = -1;
}

sub calc_diff(@v, @d, Int $w, Int $h) {
    my $total = 0;
    for (flat ^$h X ^$w) -> $i, $j {
        my @neighbors = grep *.defined, @v[$i-1][$j], @v[$i][$j-1], @v[$i+1][$j], @v[$i][$j+1];
        my $v = [+] @neighbors;
        @d[$i][$j] = $v = @v[$i][$j] - $v / +@neighbors;
        $total += $v * $v unless @fixed[$i][$j];
    }
    return $total;
}

sub iter(@v, Int $w, Int $h) {
    my @d = allocmesh($w, $h);
    my $diff = 1e10;
    my @cur = 0, 0, 0;

    while $diff > 1e-24 {
        force-v(@v);
        $diff = calc_diff(@v, @d, $w, $h);
        for (flat ^$h X ^$w) -> $i, $j {
            @v[$i][$j] -= @d[$i][$j];
        }
    }

    for (flat ^$h X ^$w) -> $i, $j {
        @cur[ @fixed[$i][$j] + 1 ]
            += @d[$i][$j] * (?$i + ?$j + ($i < $h - 1) + ($j < $w - 1));
    }

    return (@cur[2] - @cur[0]) / 2;
}

my @mesh = allocmesh($S, $S);

@fixed = allocmesh($S, $S);
force-fixed(@fixed);

say 2 / iter(@mesh, $S, $S);
