use strict;
use warnings;
use ntheory qw(:all);
use List::Util qw(uniq);

sub first_square {
    my ($base) = @_;

    my $start = sqrtint(fromdigits([1, 0, 2 .. $base-1], $base));

    for (my $k = $start ; ; ++$k) {
        if (uniq(todigits($k * $k, $base)) == $base) {
            return $k * $k;
        }
    }
}

foreach my $n (2 .. 16) {
    my $s = first_square($n);
    printf("Base %2d: %10s² == %s\n", $n,
        todigitstring(sqrtint($s), $n), todigitstring($s, $n));
}
