use strict;
use warnings;
use Math::AnyNum qw(imod is_prime);

my($x,@D) = 2;
while ($x++) {
    push @D, $x if 1 == $x%2 and !is_prime $x and 0 == imod(1x($x-1),$x);
    last if 25 == @D
}
print "@D\n";
