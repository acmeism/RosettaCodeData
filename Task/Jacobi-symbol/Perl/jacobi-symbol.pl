use strict;
use warnings;

sub J {
    my($k,$n) = @_;

    $k %= $n;
    my $jacobi = 1;
    while ($k) {
        while (0 == $k % 2) {
            $k = int $k / 2;
            $jacobi *= -1 if $n%8 == 3 or $n%8 == 5;
        }
        ($k, $n) = ($n, $k);
        $jacobi *= -1 if $n%4 == 3 and $k%4 == 3;
        $k %= $n;
    }
    $n == 1 ? $jacobi : 0
}

my $maxa = 1 + (my $maxn = 29);

print 'n\k';
printf '%4d', $_ for 1..$maxa;
print "\n";
print '   ' . '-' x (4 * $maxa) . "\n";

for my $n (1..$maxn) {
    next if 0 == $n % 2;
    printf '%3d', $n;
    printf '%4d', J($_, $n) for 1..$maxa;
    print "\n"
}
