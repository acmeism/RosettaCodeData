#!/usr/bin/perl
use strict;
use warnings;

my @doors = (1) x 100;
for my $N (1 .. 100) {
   $doors[$_]=1-$doors[$_] for map { $_*$N - 1 } 1 .. int(100/$N);
}
print join("\n", map { "Door $_ is Open" } grep { ! $doors[$_-1] } 1 .. 100), "\n";
print "The rest are closed\n";
