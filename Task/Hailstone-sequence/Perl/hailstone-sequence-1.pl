#!/usr/bin/perl

use warnings;
use strict;

my @h = hailstone(27);
print "Length of hailstone(27) = " . scalar @h . "\n";
print "[" . join(", ", @h[0 .. 3], "...", @h[-4 .. -1]) . "]\n";

my ($max, $n) = (0, 0);
for my $x (1 .. 99_999) {
    @h = hailstone($x);
    if (scalar @h > $max) {
        ($max, $n) = (scalar @h, $x);
    }
}

print "Max length $max was found for hailstone($n) for numbers < 100_000\n";


sub hailstone {
    my ($n) = @_;

    my @sequence = ($n);

    while ($n > 1) {
        if ($n % 2 == 0) {
            $n = int($n / 2);
        } else {
            $n = $n * 3 + 1;
        }

        push @sequence, $n;
    }

    return @sequence;
}
