use strict;
use warnings;

my @denominations = <200 100 50 20 10 5 2 1>;

sub change {
    my $n = shift;
    my @a;
    push(@a, int $n/$_) and $n %= $_ for @denominations;
    @a
}

my @amounts = change 988;
for (0 .. $#amounts) {
    printf "%1d * %3d\n", $amounts[$_], $denominations[$_]
}
