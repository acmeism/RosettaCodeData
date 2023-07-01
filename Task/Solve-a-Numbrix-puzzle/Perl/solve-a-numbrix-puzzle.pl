#!/usr/bin/perl

use strict;
use warnings;

$_ = <<END;
 0  0  0  0  0  0  0  0  0
 0  0 46 45  0 55 74  0  0
 0 38  0  0 43  0  0 78  0
 0 35  0  0  0  0  0 71  0
 0  0 33  0  0  0 59  0  0
 0 17  0  0  0  0  0 67  0
 0 18  0  0 11  0  0 64  0
 0  0 24 21  0  1  2  0  0
 0  0  0  0  0  0  0  0  0
END

my $gap = /.\n/ * $-[0];
print;
s/ (?=\d\b)/0/g;
my $max = sprintf "%02d", tr/0-9// / 2;

solve( '01', $_ );

sub solve
  {
  my ($have, $in) = @_;
  $have eq $max and exit !print "solution\n", $in =~ s/\b0/ /gr;
  if( $in =~ ++(my $want = $have) )
    {
    $in =~ /($have|$want)( |.{$gap})($have|$want)/s and solve($want, $in);
    }
  else
    {
    ($_ = $in) =~ s/$have \K00/$want/          and solve( $want, $_ ); # R
    ($_ = $in) =~ s/$have.{$gap}\K00/$want/s   and solve( $want, $_ ); # D
    ($_ = $in) =~ s/00(?= $have)/$want/        and solve( $want, $_ ); # L
    ($_ = $in) =~ s/00(?=.{$gap}$have)/$want/s and solve( $want, $_ ); # U
    }
  }
