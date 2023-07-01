use strict;
use warnings;
use Math::AnyNum qw(:overload powmod);

sub B10 {
    my($n) = @_;
    return 0 unless $n;

    my @P = (-1) x $n;
    for (my $m = 0; $P[0] == -1; ++$m) {
        for my $r (0..$n-1) {
            next if $P[$r] == -1 or $P[$r] == $m;
            for ((powmod(10, $m, $n) + $r) % $n) { $P[$_] = $m if $P[$_] == -1 }
        }
        for (powmod(10, $m, $n)) { $P[$_] = $m if $P[$_] == -1 }
    }

    my $R = my $r = 0;
    do {
        $R += 10**$P[$r];
        $r  = ($r - powmod(10, $P[$r], $n)) % $n
    } while $r > 0;
    $R
}

printf "%5s: %28s  %s\n", 'Number', 'B10', 'Multiplier';

for my $n (1..10, 95..105, 297, 576, 594, 891, 909, 999, 1998, 2079, 2251, 2277, 2439, 2997, 4878) {
    my $a = B10($n);
    printf "%6d: %28s  %s\n", $n, $a, $a/$n;
}
