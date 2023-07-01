use strict;
use warnings;

my ($n,@D) = (0, 0);
while (++$n) {
    my($m,$sum);
    map { $sum += $_ ** ++$m } split '', $n;
    push @D, $n if $n == $sum;
    last if 19 == @D;
}
print "@D\n";
