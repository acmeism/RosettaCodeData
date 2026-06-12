#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Vibrating_rectangles
use warnings;
use Tk;

my ($half, $gap, @ids) = (470, 12);
my @colors = glob '#' . '{00,ff}'x3;
my $mw = MainWindow->new;
my $c = $mw->Canvas( -width => $half << 1, -height => $half << 1 )->pack;
for(my $x = $half - $gap; $x > 0; $x -= $gap )
  {
  push @ids, $c->createRectangle(($half - $x) x 2, ($half + $x) x 2,
    -outline => 'gray', -width => 9 );
  }
my $lastid = $ids[-1];
$mw->repeat( 25 => sub
  {
  $c->itemconfigure( $ids[0], -outline => $colors[0] );
  $ids[0] eq $lastid and push @colors, shift @colors;
  push @ids, shift @ids;
  } );
MainLoop;
