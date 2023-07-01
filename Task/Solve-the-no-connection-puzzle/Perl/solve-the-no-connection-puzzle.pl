#!/usr/bin/perl

use strict;
use warnings;

my $gap = qr/.{3}/s;

find( <<terminator );
-AB-
CDEF
-GH-
terminator

sub find
  {
  my $p = shift;
  $p =~ /(\d)$gap.{0,2}(\d)(??{abs $1 - $2 <= 1 ? '' : '(*F)'})/ ||
    $p =~ /^.*\n.*(\d)(\d)(??{abs $1 - $2 <= 1 ? '' : '(*F)'})/ and return;
  if( $p =~ /[A-H]/ )
    {
    find( $p =~ s/[A-H]/$_/r ) for grep $p !~ $_, 1 .. 8;
    }
  else
    {
    print $p =~ tr/-/ /r;
    exit;
    }
  }
