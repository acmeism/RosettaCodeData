#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Animated_Spinners#
use warnings;
use Tk;

my $half = (my $size = 500) >> 1;
my $twopi = 4 * atan2 1, 0;
my $dial = $size * 0.20;
my $angle = 0;
my $rotate = 0.05;
my $delay = 1000 / 120;
my $inset = $size >> 4;
my $mw = MainWindow->new;
$mw->geometry('+400+200');
my $c = $mw->Canvas(-width => $size, -height => $size, -bg => 'gray10',
  )->pack;
$c->createOval( ($inset) x 2, ($size - $inset) x 2,
  -fill => 'black', -outline => 'gray20', -width => 2);

$mw->repeat(1000 => sub{-M $0 < 0 and exec $0});
rotate();
MainLoop;

sub rotate
  {
  $c->delete( 'spinner' );
  ($angle += $rotate) > $twopi and $angle -= $twopi;
  my ($xo, $yo) = map $dial * $_, cos $angle, sin $angle;
  for ( split /^/, <<~END )
    0.50 0.50 green
    0.35 0.35 red
    0.65 0.35 yellow
    0.35 0.65 white
    0.65 0.65 orange
    END
    {
    my ($x, $y, $color) = split;
    $c->createLine(
      $size * $x, $size * $y,
      $size * $x + $xo, $size * $y + $yo,
      -fill => $color, -width => 3, -tag => 'spinner');
    }
  $mw->after($delay => \&rotate);
  }
