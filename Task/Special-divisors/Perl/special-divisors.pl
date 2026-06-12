use strict;
use warnings;
use feature 'say';
use ntheory 'divisors';

my @sd;
for my $n (1..199) {
    map { next if $_ != int $_ } map { reverse($n) / reverse $_ } divisors $n;
    push @sd, $n;
}

say @sd . " matching numbers:\n" .
    (sprintf "@{['%4d' x @sd]}", @sd) =~ s/(.{40})/$1\n/gr;
