constant @vecs = [1,0,1], [0,-1,1], [-1,0,1], [0,1,1];
constant @blocky = ' ▘▝▀▖▌▞▛▗▚▐▜▄▙▟█'.comb;
constant $size = 100;
enum Square <White Black>;
my @plane = [White xx $size] xx $size;
my ($x, $y) = $size/2, $size/2;
my $dir = @vecs.keys.pick;
my $moves = 0;
loop {
    given @plane[$x][$y] {
        when :!defined { last }
        when White { $dir--; $_ = Black; }
        when Black { $dir++; $_ = White; }
    }
    ($x,$y,$moves) »+=« @vecs[$dir %= @vecs];
}
say "Out of bounds after $moves moves at ($x, $y)";
for 0,2,4 ... $size - 2 -> $y {
    say join '', gather for 0,2,4 ... $size - 2 -> $x {
        take @blocky[ 1 * @plane[$x][$y]
                    + 2 * @plane[$x][$y+1]
                    + 4 * @plane[$x+1][$y]
                    + 8 * @plane[$x+1][$y+1] ];
    }
}
