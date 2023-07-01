use strict;
use warnings;
use Math::AnyNum qw(:overload as_bin digits2num);

for my $x (1..10, 95..105, 297, 576, 594, 891, 909, 999) {
    my $y;
    if ($x =~ /^9+$/) { $y = digits2num([(1) x (9 * length $x)],2)  } # all 9's implies all 1's
    else              { while (1) { last unless as_bin(++$y) % $x } }
    printf "%4d: %28s  %s\n", $x, as_bin($y), as_bin($y)/$x;
}
