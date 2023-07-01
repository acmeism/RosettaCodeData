#!/usr/bin/perl

use strict;
use warnings;

sub rf
  {
  local $_ = shift;
  my $sum = 0;
  $sum += $1 <=> $2 while /(.)(?=(.))/g;
  $sum
  }

my $count = 0;
my $n = 0;
my @numbers;
while( $count < 200 )
  {
  rf(++$n) or $count++, push @numbers, $n;
  }
print "first 200: @numbers\n" =~ s/.{1,70}\K\s/\n/gr;

$count = 0;
$n = 0;
while( $count < 10e6 )
  {
  rf(++$n) or $count++;
  }
print "\n10,000,000th number: $n\n";
