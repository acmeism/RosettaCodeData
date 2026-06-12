#!/usr/bin/perl -l

use strict; # https://rosettacode.org/wiki/Sort_the_letters_of_string_in_alphabitical_order
use warnings;

my @lines = split /\n/, <<END;
The quick brown fox jumps over the lazy dog, apparently
Now is the time for all good men to come to the aid of their country.
END

for ( @lines, 'dcba', 'sort this string' )
  {
  print "\n$_";
  print builtinsort($_); #     using built in sort
  print sortstring($_);  # not using built in sort
  print inplace($_);     # not using built in sort
  }

sub builtinsort
  {
  return join '', sort split //, shift;
  }

sub sortstring # IBM card sorters forever !! (distribution sort)
  {
  my @chars;
  $chars[ord] .= $_ for split //, shift;
  no warnings; # hehehe
  return join '', @chars;
  }

sub inplace # just swap any adjacent pair not in order until none found
  {
  local $_ = shift;
  1 while s/(.)(.)(??{$1 le $2 && '(*FAIL)'})/$2$1/g;
  return $_;
  }
