use strict;
use warnings;
use feature 'say';
use ntheory 'divisor_sum';

my @x;
push @x, scalar divisor_sum($_) for 1..100;

say "Divisor sums - first 100:\n" .
    ((sprintf "@{['%4d' x 100]}", @x[0..100-1]) =~ s/(.{80})/$1\n/gr);
