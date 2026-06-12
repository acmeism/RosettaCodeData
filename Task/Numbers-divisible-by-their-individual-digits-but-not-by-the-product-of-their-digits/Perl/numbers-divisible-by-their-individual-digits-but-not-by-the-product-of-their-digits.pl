#!/usr/bin/perl

use strict;
use warnings;

my @numbers = grep
  {
  my $n = $_;
  ! /0/ and $_ % eval s/\B/*/gr and 0 == grep $n % $_, split //
  } 1 .. 999;

print @numbers . " numbers found\n\n@numbers\n" =~ s/.{25}\K /\n/gr;
