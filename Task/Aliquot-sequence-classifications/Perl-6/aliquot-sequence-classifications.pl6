sub propdivsum (\x) {
    [+] x > 1, gather for 2 .. x.sqrt.floor -> \d {
        my \y = x div d;
        if y * d == x { take d; take y unless y == d }
    }
}

multi quality (0,1)  { 'perfect ' }
multi quality (0,2)  { 'amicable' }
multi quality (0,$n) { "sociable-$n" }
multi quality ($,1)  { 'aspiring' }
multi quality ($,$n) { "cyclic-$n" }

sub aliquotidian ($x) {
    my %seen;
    my @seq = $x, &propdivsum ... *;
    for 0..16 -> $to {
        my $this = @seq[$to] or return "$x\tterminating\t[@seq[^$to]]";
        last if $this > 140737488355328;
        if %seen{$this}:exists {
            my $from = %seen{$this};
            return "$x\t&quality($from, $to-$from)\t[@seq[^$to]]";
        }
        %seen{$this} = $to;
    }
    "$x non-terminating";

}

aliquotidian($_).say for flat
    1..10,
    11, 12, 28, 496, 220, 1184, 12496, 1264460,
    790, 909, 562, 1064, 1488,
    15355717786080;
