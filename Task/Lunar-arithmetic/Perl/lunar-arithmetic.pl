#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Lunar_arithmetic
use warnings;
use List::AllUtils qw( min max zip_by uniq );

sub lunaradd
  {
  my $pad = max map length, @_;
  join '', zip_by { max @_ } map [ (0) x ($pad - length), /./g ], @_;
  }

sub lunarmultiply
  {
  my ($pad, $x, $y) = (0, shift, @_ > 1 ? lunarmultiply(@_) : @_);
  lunaradd map $x =~ s/./ min $_, $& /ger . 0 x $pad++, reverse $y =~ /./g;
  }

printf "%d <+> " x $#$_ . "%d == %d\n" . "%d <*> " x $#$_ . "%d == %d\n\n",
  @$_, lunaradd(@$_), @$_, lunarmultiply(@$_)
  for [976, 348], [23, 321], [232, 35], [123, 32192, 415, 8];

my ($n, @distinct) = 0;
1 while ( @distinct = uniq @distinct, lunarmultiply( 2, $n++ ) ) < 20;
print "distinct evens: @distinct\n\n";

print "squares: @{[ map lunarmultiply($_, $_), 0 .. 19 ]}\n\n";

print "factorials: @{[ (1, map lunarmultiply(1 .. $_), 2 .. 20) ]}\n\n";

my @sqr = (0, 1);
push @sqr, lunarmultiply( (1 + @sqr) x 2 ) until $sqr[-2] > $sqr[-1];
print "first smaller square: " . @sqr . "\n";
