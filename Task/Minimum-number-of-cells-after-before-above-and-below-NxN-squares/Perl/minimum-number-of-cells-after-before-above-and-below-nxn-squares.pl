use strict;
use warnings;
use List::Util qw( max min );

for my $N (0, 1, 2, 6, 9, 23) {
    my $fmt = ('%' . (1+length int $N/2) . 'd') x $N . "\n";
    print "$N x $N distance to nearest edge:\n";
    for my $row ( 0 .. $N-1 ) {
        my @cols = map { min $_, $row, $N-1 - max $_, $row } 0 .. $N-1;
        printf $fmt, @cols;
    }
    print "\n";
}
