#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/4-rings_or_4-squares_puzzle
use warnings;

for ( [1 .. 7], [3 .. 9] )
  {
  print "for @$_\n\n";
  findunique( $_ );
  print "\n";
  }
my $count = 0;
findcount();
print "count of non-unique 0-9: $count\n";

sub findunique
  {
  my @allowed = @{ shift @_ };
  if( @_ == 4 ) { $_[0] == $_[2] + $_[3] or return }
  elsif( @_ == 6 ) { $_[1] + $_[2] == $_[4] + $_[5] or return }
  elsif( @_ == 7 ) { $_[3] + $_[4] == $_[6] and print "@_\n"; return }
  for my $n ( @allowed )
    {
    findunique( [ grep $n != $_, @allowed ], @_, $n );
    }
  }

sub findcount
  {
  if( @_ == 4 ) { $_[0] == $_[2] + $_[3] or return }
  elsif( @_ == 6 ) { $_[1] + $_[2] == $_[4] + $_[5] or return }
  elsif( @_ == 7 ) { $_[3] + $_[4] == $_[6] and $count++; return }
  findcount( @_, $_ ) for 0 .. 9;
  }
