#!/usr/bin/perl

use strict;
use warnings;
use ntheory qw( factor vecsum );
use List::AllUtils qw( uniq );

#use Data::Dump 'dd'; dd factor(6); exit;

my $n = 1;
my @answers;
while( @answers < 30 )
  {
  vecsum(factor($n)) == vecsum(factor($n+1)) and push @answers, $n;
  $n++;
  }
print "factors:\n\n@answers\n\n" =~ s/.{60}\K /\n/gr;

$n = 1;
@answers = ();
while( @answers < 30 )
  {
  vecsum(uniq factor($n)) == vecsum(uniq factor($n+1)) and push @answers, $n;
  $n++;
  }
print "divisors:\n\n@answers\n" =~ s/.{60}\K /\n/gr;
