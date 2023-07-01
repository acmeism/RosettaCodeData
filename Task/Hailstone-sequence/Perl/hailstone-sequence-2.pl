#!/usr/bin/perl
use strict;

sub hailstone {
    @_ = local $_ = shift;
    push @_, $_ = $_ % 2 ? 3 * $_ + 1 : $_ / 2 while $_ > 1;
    @_;
}

my @h = hailstone($_ = 27);
print "$_: @h[0 .. 3] ... @h[-4 .. -1] (".@h.")\n";

@h = ();
for (1 .. 99_999) { @h = ($_, $h[2]) if ($h[2] = hailstone($_)) > $h[1] }
printf "%d: (%d)\n", @h;
