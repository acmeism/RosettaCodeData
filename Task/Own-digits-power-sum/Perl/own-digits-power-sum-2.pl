use strict;
use warnings;
use List::Util 'sum';
use Algorithm::Combinatorics qw<combinations_with_repetition>;

my @own_dps;
for my $d (3..9) {
    my $iter = combinations_with_repetition([0..9], $d);
    while (my $p = $iter->next) {
        my $dps = sum map { $_**$d } @$p;
        next unless $d == length $dps and join('', @$p) == join '', sort split '', $dps;
        push @own_dps, $dps;
    }
}

print join "\n", sort { $a <=> $b } @own_dps;
