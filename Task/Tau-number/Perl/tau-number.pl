use strict;
use warnings;
use feature 'say';
use ntheory 'divisors';

my(@x,$n);

do { push(@x,$n) unless $n % scalar(divisors(++$n)) } until 100 == @x;

say "Tau numbers - first 100:\n" .
    ((sprintf "@{['%5d' x 100]}", @x[0..100-1]) =~ s/(.{80})/$1\n/gr);
