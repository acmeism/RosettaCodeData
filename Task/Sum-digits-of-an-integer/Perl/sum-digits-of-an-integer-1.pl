#!/usr/bin/perl
use strict;
use warnings;

my %letval = map { $_ => $_ } 0 .. 9;
$letval{$_} = ord($_) - ord('a') + 10 for 'a' .. 'z';
$letval{$_} = ord($_) - ord('A') + 10 for 'A' .. 'Z';

sub sumdigits {
  my $number = shift;
  my $sum = 0;
  $sum += $letval{$_} for (split //, $number);
  $sum;
}

print "$_ sums to " . sumdigits($_) . "\n"
  for (qw/1 1234 1020304 fe f0e DEADBEEF/);
