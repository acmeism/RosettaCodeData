use strict;
use warnings;
use feature 'say';
use ntheory 'divisors';

my @x;
push @x, scalar divisors($_) for 1..100;

say "Tau function - first 100:\n" .
    ((sprintf "@{['%4d' x 100]}", @x[0..100-1]) =~ s/(.{80})/$1\n/gr);
