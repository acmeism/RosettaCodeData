use strict;
use warnings;
use Math::AnyNum qw(sum polymod);

sub fairshare {
    my($b, $n) = @_;
    sprintf '%3d'x$n, map { sum ( polymod($_, $b, $b )) % $b } 0 .. $n-1;
}

for (<2 3 5 11>) {
    printf "%3s:%s\n", $_, fairshare($_, 25);
}
