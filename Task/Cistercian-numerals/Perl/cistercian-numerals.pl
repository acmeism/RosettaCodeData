#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Cistercian_numerals
use warnings;

my @pts = ('', qw( 01 23 03 12 012 13 013 132 0132) );
my @dots = qw( 4-0 8-0 4-4 8-4 );

my @images = map { sprintf("%-9s\n", "$_:") . draw($_) }
  0, 1, 20, 300, 4000, 5555, 6789, 1133;
for ( 1 .. 13 )
  {
  s/(.+)\n/ print " $1"; '' /e for @images;
  print "\n";
  }

sub draw
  {
  my $n = shift;
  local $_ = "    #    \n" x 12;
  my $quadrant = 0;
  for my $digit ( reverse split //, sprintf "%04d", $n )
    {
    my ($oldx, $oldy);
    for my $cell ( split //, $pts[$digit] )
      {
      my ($x, $y) = split /-/, $dots[$cell];
      if( defined $oldx )
        {
        my $dirx = $x <=> $oldx;
        my $diry = $y <=> $oldy;
        for my $place ( 0 .. 3 )
          {
          substr $_, $oldx + $oldy * 10, 1, '#';
          $oldx += $dirx;
          $oldy += $diry;
          }
        }
      ($oldx, $oldy) = ($x, $y);
      }
    s/.+/ reverse $& /ge;
    ++$quadrant & 1 or $_ = join '', reverse /.+\n/g;
    }
  return $_;
  }
