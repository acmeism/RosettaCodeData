#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Latin_Squares_in_reduced_form
use warnings;

my $n = 0;
my $count;
our @perms;

while( ++$n <= 7 )
  {
  $count = 0;
  @perms = perm( my $start = join '', 1 .. $n );
  find( $start );
  print "order $n size $count total @{[$count * fact($n) * fact($n-1)]}\n\n";
  }

sub find
  {
  @_ >= $n and return $count += ($n != 4) || print join "\n", @_, "\n";
  local @perms = grep 0 == ($_[-1] ^ $_) =~ tr/\0//, @perms;
  my $row = @_ + 1;
  find( @_, $_ ) for grep /^$row/, @perms;
  }

sub fact { $_[0] > 1 ? $_[0] * fact($_[0] - 1) : 1 }

sub perm
  {
  my $s = shift;
  length $s <= 1 ? $s :
    map { my $f = $_; map "$f$_", perm( $s =~ s/$_//r ) } split //, $s;
  }
