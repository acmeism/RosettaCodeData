use strict;
use warnings;
use feature 'say';

sub dual_diagonal {
    my($n) = shift() - 1;
    my @m;
    for (0..$n) {
        my @rr = reverse my @r = ( (0) x $_, 1, (0) x ($n-$_) );
        push @m, [ map { $r[$_] or $rr[$_] } 0..$n ]
    }
    @m
}

say join ' ', @$_ for dual_diagonal(4); say '';
say join ' ', @$_ for dual_diagonal(5);
