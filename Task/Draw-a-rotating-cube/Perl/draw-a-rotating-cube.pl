#!/usr/bin/perl

use strict;              # http://www.rosettacode.org/wiki/Draw_a_rotating_cube
use warnings;
use Tk;
use Time::HiRes qw( time );

my $size = 600;
my $wait = int 1000 / 30;
my ($height, $width) = ($size, $size * sqrt 8/9);
my $mid = $width / 2;
my $rot = atan2(0, -1) / 3;                   # middle corners every 60 degrees

my $mw = MainWindow->new;
my $c = $mw->Canvas(-width => $width, -height => $height)->pack;
$c->Tk::bind('<ButtonRelease>' => sub {$mw->destroy});          # click to exit
draw();
MainLoop;

sub draw
  {
  my $angle = time - $^T;                    # full rotation every 2*PI seconds
  my @points = map { $mid + $mid * cos $angle + $_ * $rot,
    $height * ($_ % 2 + 1) / 3 } 0 .. 5;
  $c->delete('all');
  $c->createLine( @points[-12 .. 1], $mid, 0, -width => 5,);
  $c->createLine( @points[4, 5], $mid, 0, @points[8, 9], -width => 5,);
  $c->createLine( @points[2, 3], $mid, $height, @points[6, 7], -width => 5,);
  $c->createLine( $mid, $height, @points[10, 11], -width => 5,);
  $mw->after($wait, \&draw);
  }
