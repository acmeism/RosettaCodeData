use strict;
use warnings;
use feature 'say';
use ntheory 'is_prime';

my($low, $high) = (100, 500);
my $n = my @SP = grep { my @d = split ''; is_prime $d[0]+$d[1] and is_prime $d[1]+$d[2] } $low+1 .. $high-1;
say "Between $low and $high there are $n strange-plus numbers:\n" .
    (sprintf "@{['%4d' x $n]}", @SP[0..$n-1]) =~ s/(.{80})/$1\n/gr;
