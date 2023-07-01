use strict;
use warnings;

sub sleeping_beauty {
    my($trials) = @_;
    my($gotheadsonwaking,$wakenings);
    $wakenings++ and rand > .5 ? $gotheadsonwaking++ : $wakenings++ for 1..$trials;
    $wakenings, $gotheadsonwaking/$wakenings
}

my $trials = 1_000_000;
printf "Wakenings over $trials experiments: %d\nSleeping Beauty should estimate a credence of: %.4f\n", sleeping_beauty($trials);
