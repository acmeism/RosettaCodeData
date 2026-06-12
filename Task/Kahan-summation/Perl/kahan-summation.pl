use strict;
use warnings;
use feature 'say';

sub kahan {
    my(@nums) = @_;
    my $summ = my $c = 0e0;
    for my $num (@nums) {
        my $y = $num - $c;
        my $t = $summ + $y;
        $c = ($t - $summ) - $y;
        $summ = $t;
    }
    $summ
}

my $eps = 1;
do { $eps /= 2 } until 1e0 == 1e0 + $eps;

say 'Epsilon:    ' . $eps;
say 'Simple sum: ' . sprintf "%.16f", ((1e0 + $eps) - $eps);
say 'Kahan sum:  ' . sprintf "%.16f", kahan(1e0, $eps, -$eps);
