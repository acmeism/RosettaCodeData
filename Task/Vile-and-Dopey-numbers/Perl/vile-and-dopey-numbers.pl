#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Vile_and_Dopey_numbers#
use warnings;
use List::AllUtils qw( indexes count_by );

sub vile { (sprintf '%b', shift) =~ /1(00)*\z/ ? 'vile' : 'dopey' }

my @is = map { vile $_ } 0 .. 2**10;
my @vile = grep $_, indexes { $_ eq 'vile' } @is;
print "first 25 vile @vile[0 .. 24]\n";
my @dopey = grep $_, indexes { $_ eq 'dopey' } @is;
print "first 25 dopey @dopey[0 .. 24]\n";

print "upto:  vile  dopey\n";
for (1 .. 10)
  {
  my %counts = count_by { $_ } @is[1 .. 2**$_];
  printf "%4d%7d%7d\n", 2**$_, @counts{qw(vile dopey)};
  }
