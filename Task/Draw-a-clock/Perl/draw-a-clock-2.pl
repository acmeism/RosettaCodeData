#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Draw_a_clock
use warnings;
use Tk;

my $halfsize = 200;
my $twopi = 2 * atan2 0, -1;
my $mw = MainWindow->new;
my $c = $mw->Canvas( -width => 2 * $halfsize, -height => 2 * $halfsize)->pack;
$mw->repeat(1000 => \&draw);
MainLoop;

sub draw
  {
  $c->delete('all');
  my $angle = time % 60 / 60 * $twopi;
  $c->createLine( $halfsize, $halfsize,
    $halfsize * (1 + sin $angle),
    $halfsize * (1 - cos $angle),
    -width => 5);
  }
