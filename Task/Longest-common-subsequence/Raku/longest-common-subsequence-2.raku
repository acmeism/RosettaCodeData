sub lcs(Str $xstr, Str $ystr) {
    my ($xlen, $ylen) = ($xstr, $ystr)>>.chars;
    my @lengths = map {[(0) xx ($ylen+1)]}, 0..$xlen;

    for $xstr.comb.kv -> $i, $x {
        for $ystr.comb.kv -> $j, $y {
            @lengths[$i+1][$j+1] = $x eq $y ?? @lengths[$i][$j]+1 !! (@lengths[$i+1][$j], @lengths[$i][$j+1]).max;
        }
    }

    my @x = $xstr.comb;
    my ($x, $y) = ($xlen, $ylen);
    my $result = "";
    while $x != 0 && $y != 0 {
        if @lengths[$x][$y] == @lengths[$x-1][$y] {
            $x--;
        }
        elsif @lengths[$x][$y] == @lengths[$x][$y-1] {
            $y--;
        }
        else {
            $result = @x[$x-1] ~ $result;
            $x--;
            $y--;
        }
    }

    return $result;
}

say lcs("thisisatest", "testing123testing");
