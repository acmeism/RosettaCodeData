use strict;
use warnings;
use feature 'say';
use Math::AnyNum ':overload';
use List::AllUtils 'firstidx';

my(@H,$n) = 0;
do { ++$n and push @H, $H[-1] + 1/$n } until $H[-1] >= 10;
shift @H;

say 'First twenty harmonic numbers as rationals:';
my $c = 0;
printf("%20s", $_) and (not ++$c%5) and print "\n" for @H[0..19];

say "\nIndex of first value (zero based):";
for my $i (1..10) {
    printf "  greater than %2d: %5s\n", $i, firstidx { $_ > $i } @H;
}
