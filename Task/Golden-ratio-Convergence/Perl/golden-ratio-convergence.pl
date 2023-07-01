use strict; use warnings;
use constant phi => (1 + sqrt 5) / 2;

sub GR { my $n = shift; $n == 1 ? 2 : 1 + 1 / GR($n - 1) }

my $i;
while (++$i) {
    my $dev = abs phi - GR($i);
    (printf "%d iterations: %8.6f vs %8.6f (%8.6f)\n", $i, phi, GR($i), $dev and last) if $dev < 1e-5;
}
