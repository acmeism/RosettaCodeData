#!/usr/bin/perl
use strict;
use warnings;
use PDL;

sub kron {
    my ($x, $y) = @_;

    return $x->dummy(0)
             ->dummy(0)
             ->mult($y, 0)
             ->clump(0, 2)
             ->clump(1, 2)
}

my @mats = (
	[pdl([[1, 2], [3, 4]]),
         pdl([[0, 5], [6, 7]])],
	[pdl([[0, 1, 0], [1, 1, 1], [0, 1, 0]]),
         pdl([[1, 1, 1, 1], [1, 0, 0, 1], [1, 1, 1, 1]])],
);
for my $mat (@mats) {
	print "A = $mat->[0]\n";
	print "B = $mat->[1]\n";
	print "kron(A,B) = " . kron($mat->[0], $mat->[1]) . "\n";
}
