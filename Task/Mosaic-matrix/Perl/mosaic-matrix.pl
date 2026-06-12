use strict;
use warnings;
use feature 'say';

my $n = 5;
say join ' ', @$_ for map { $_%2 ? [map { $_%2 ? 1 : 0 } 1..$n] : [map { $_%2 ? 0 : 1 } 1..$n] } 1..$n;
