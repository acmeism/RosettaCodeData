#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Polyspiral
use warnings;
use Tk;
use List::Util qw( min );

my $size = 500;
my ($width, $height, $x, $y, $dist);
my $angleinc = 0;
my $active = 0;
my $wait = 1000 / 30;
my $radian = 90 / atan2 1, 0;

my $mw = MainWindow->new;
$mw->title( 'Polyspiral' );
my $c = $mw->Canvas( -width => $size, -height => $size,
  -relief => 'raised', -borderwidth => 2,
  )->pack(-fill => 'both', -expand => 1);
$mw->bind('<Configure>' => sub { $width = $c->width; $height = $c->height;
  $dist = min($width, $height) ** 2 / 4 } );
$mw->Button(-text => $_->[0], -command => $_->[1],
  )->pack(-side => 'right') for
  [ Exit => sub {$mw->destroy} ],
  [ 'Start / Pause' => sub { $active ^= 1; step() } ];

MainLoop;
-M $0 < 0 and exec $0;

sub step
  {
  $active or return;
  my @pts = ($x = $width >> 1, $y = $height >> 1);
  my $length = 5;
  my $angle = $angleinc;
  $angleinc += 0.05 / $radian;
  while( ($x - $width / 2)**2 + ($y - $height / 2)**2 < $dist && @pts < 300 )
    {
    push @pts, $x, $y;
    $x += $length * cos($angle);
    $y += $length * sin($angle);
    $length += 3;
    $angle += $angleinc;
    }
  $c->delete('all');
  $c->createLine( @pts );
  $mw->after($wait => \&step);
  }
