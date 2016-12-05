my @todo = $[1];
my @sums = 0;
sub nextrow($n) {
    for +@todo .. $n -> $l {
        @sums[$l] = 0;
        print $l,"\r" if $l < $n;
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
say .fmt('%2d'), ": ", nextrow($_)[] for 1..10;


say "\nsums:";
for 23, 123, 1234, 12345 {
    say $_, "\t", [+] nextrow($_)[];
}
