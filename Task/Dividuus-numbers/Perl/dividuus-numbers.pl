#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Dividuus_numbers
use warnings;
use ntheory qw( sumdigits );
use List::AllUtils qw( product );
$SIG{__WARN__} = sub { die @_ };

sub digitalroot
  {
  my $n = shift;
  $n = sumdigits($n) while length $n > 1;
  return $n;
  }

sub multiplicativedigitalroot
  {
  my $n = shift;
  $n = product(split //, $n) while length $n > 1;
  return $n;
  }

sub dividuus
  {
  my $n = shift;
  $n % sumdigits($n) == 0 or return 0;
  $n % (product(split //, $n) || return 0) == 0 or return 0;
  $n % (digitalroot($n) || return 0) == 0 or return 0;
  $n % (multiplicativedigitalroot($n) || return 0) == 0 or return 0;
  return 1;
  }

my @numbers;
my $n = 1;
while( @numbers < 50 )
  {
  dividuus($n) and push @numbers, $n;
  $n++;
  }
print "First fifty Dividuus numbers:\n",
  (join '', map { sprintf '%6d', $_ } @numbers) =~ s/.{60}\K/\n/gr;

@numbers = ();
for my $n ( 990000000 .. 1000000000 )
  {
  dividuus($n) and push @numbers, $n;
  }
print "\nDividuus numbers between 99000000 and 1000000000:\n@numbers\n";
