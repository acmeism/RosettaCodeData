#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Rice_coding
use warnings;

sub rice # args k arrayofnumbers
  {
  my $k = shift;
  join '', map { 1 x ($_ >> $k) . 0 . sprintf "%0*b", $k, $_ % 2**$k } @_;
  }

sub derice # args k stringof0and1representingbinarydata
  {
  (my $k, local $_) = @_;
  my @answers;
  push @answers, (length($1) << $k) + oct "0b$2" while /\G(1*)0(.{$k})/g;
  return @answers;
  }

for my $k ( 2 .. 6)
  {
  print "\nk = $k\n\n";
  my $rice = rice( $k, my @input = 0 .. 17 );
  my @decoded = derice $k, $rice;
  print "  input: @input\n   rice: $rice\ndecoded: @decoded\n";
  "@input" eq "@decoded" or die "MISMATCH";
  }
