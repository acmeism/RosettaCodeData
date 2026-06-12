#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Words_from_neighbour_ones
use warnings;

@ARGV = 'unixdict.txt';
my $skew = join '', map { s/^.{9}\K.+//r } my @words = grep length() > 9, <>;
my %dict = map { $_ => 1 } grep length == 10, @words;
my %seen;
my $nextch = '.{10}(\\w)' x 8;
while( $skew =~ /^(\w)(?=$nextch)/gms )
  {
  my $new = join '', @{^CAPTURE}, "\n";
  $dict{$new} and !$seen{$new}++ and print $new;
  }
