use strict;
use warnings;
use ntheory 'factor';

for my $m (2..20, 65) {
    my (@steps, @factors) = $m;
    push @steps, join '_', @factors while (@factors = factor $steps[-1] =~ s/_//gr) > 1;
    my $step = $#steps;
    if ($step >= 1) { print 'HP' . $_ . "($step) = " and --$step or last for @steps }
    else            { print "HP$m = " }
    print "$steps[-1]\n";
}
