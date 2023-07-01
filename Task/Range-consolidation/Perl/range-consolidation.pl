use strict;
use warnings;

use List::Util qw(min max);

sub consolidate {
    our @arr; local *arr = shift;
    my @sorted = sort { @$a[0] <=> @$b[0] } map { [sort { $a <=> $b } @$_] } @arr;
    my @merge = shift @sorted;
    for my $i (@sorted) {
        if ($merge[-1][1] >= @$i[0]) {
            $merge[-1][0] = min($merge[-1][0], @$i[0]);
            $merge[-1][1] = max($merge[-1][1], @$i[1]);
        } else {
            push @merge, $i;
        }
    }
    return @merge;
}

for my $intervals (
    [[1.1, 2.2],],
    [[6.1, 7.2], [7.2, 8.3]],
    [[4, 3], [2, 1]],
    [[4, 3], [2, 1], [-1, -2], [3.9, 10]],
    [[1, 3], [-6, -1], [-4, -5], [8, 2], [-6, -6]]) {
        my($in,$out);
        $in   = join ', ', map { '[' . join(', ', @$_) . ']' } @$intervals;
        $out .= join('..', @$_). ' ' for consolidate($intervals);
        printf "%44s => %s\n", $in, $out;
}
