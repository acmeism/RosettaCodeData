use strict;
use warnings;

for my $a (1 .. 998) {
    my $a2 = $a**2;
    for my $b ($a+1 .. 999) {
        my $c = 1000 - $a - $b;
        last if $c < $b;
        print "$a² + $b² = $c²\n$a  + $b  + $c = 1000\n" and last if $a2 + $b**2 == $c**2
    }
}
