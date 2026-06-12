use strict;
use warnings;
use feature 'say';

my $n = 5;
say join ' ', @$_ for ([(1)x$n], (map { [1, (0)x($n-2), 1] } 0..$n-3), [(1)x$n]);
