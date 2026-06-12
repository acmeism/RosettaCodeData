#!/usr/bin/perl

use strict;
use warnings;

my @queue = my @primedigits = ( 2, 3, 5, 7 );
my $numbers;

while( my $n = shift @queue )
  {
  if( eval $n == 13 )
    {
    $numbers .= $n =~ tr/+//dr . " ";
    }
  elsif( eval $n < 13 )
    {
    push @queue, map "$n+$_", @primedigits;
    }
  }
print $numbers =~ s/.{1,80}\K /\n/gr;
