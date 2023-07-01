my @todo = $[1];
my @sums = 0;
sub nextrow($n) {
    for +@todo .. $n -> $l {
        my $r = [];
        for reverse ^$l -> $x {
            my @x := @todo[$x];
            if @x {
                $r.push: @sums[$x] += @x.shift;
            }
            else {
                $r.push: @sums[$x];
            }
        }
        @todo.push($r);
    }
    @todo[$n];
}

say "rows:";
say .fmt('%2d'), ": ", nextrow($_)[] for 1..25;


my @names-of-God = 1, { partition-sum ++$ } … *;
my @names-of-God-adder = lazy [\+] flat 1, ( (1 .. *) Z (1 .. *).map: * × 2 + 1 );
sub partition-sum ($n) {
    sum @names-of-God[$n X- @names-of-God-adder[^(@names-of-God-adder.first: * > $n, :k)]]
        Z× (flat (1, 1, -1, -1) xx *)
}

say "\nsums:";
for 23, 123, 1234, 12345 {
    put $_, "\t",  @names-of-God[$_];
}
