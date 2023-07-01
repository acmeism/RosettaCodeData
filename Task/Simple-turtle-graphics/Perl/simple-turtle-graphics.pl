#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Simple_turtle_graphics
use warnings;
use Tk;
use List::Util qw( max );

my $c; # the canvas

# turtle routines

my $pen = 1; # true for pendown,  false for penup
my @location = (0, 0); # upper left corner
my $direction = 0; # 0 for East, increasing clockwise
my @stack;
my $radian = 180 / atan2 0, -1;
sub dsin { sin $_[0] / $radian }
sub dcos { cos $_[0] / $radian }
sub save { push @stack, [ $direction, @location ] }
sub restore { ($direction, @location) = @{ pop @stack } }
sub turn { $direction += shift }
sub right { turn shift }
sub left { turn -shift }
sub forward
  {
  my $x = $location[0] + $_[0] * dcos $direction;
  my $y = $location[1] + $_[0] * dsin $direction;
  $pen and $c->createLine( @location, $x, $y, -width => 3 );
  @location = ($x, $y);
  }
sub back { turn 180; forward shift; turn 180 }
sub penup { $pen = 0 }
sub pendown { $pen = 1 }
sub text { $c->createText( @location, -text => shift ) }

# make window

my $mw = MainWindow->new;
$c = $mw->Canvas(
  -width => 900, -height => 900,
  )->pack;
$mw->Button(-text => 'Exit', -command => sub {$mw->destroy},
  )->pack(-fill => 'x');
$mw->after(0, \&run);
MainLoop;
-M $0 < 0 and exec $0;

sub box
  {
  my ($w, $h) = @_;
  for (1 .. 2)
    {
    forward $w;
    left 90;
    forward $h;
    left 90;
    }
  }

sub house
  {
  my $size = shift;
  box $size, $size;
  right 90;
  for ( 1 .. 3 )
    {
    right 120;
    forward $size;
    }
  penup;
  left 90;
  forward $size;
  left 90;
  save;
  forward $size * 1 / 4;
  pendown;
  box $size / 4, $size / 2;
  penup;
  forward $size * 3 / 8;
  left 90;
  forward $size / 4;
  right 90;
  pendown;
  box $size / 4, $size / 4;
  penup;
  restore;
  save;
  forward $size / 2;
  left 90;
  forward $size + 40;
  right 90;
  pendown;
  for (1 .. 8)
    {
    forward 15;
    left 45;
    forward 15;
    }
  restore;
  penup;
  }

sub graph
  {
  save;
  my $size = shift;
  my $width = $size / @_;
  my $hscale = $size / max @_;
  for ( @_ )
    {
    box $width, $hscale * $_;
    save;
    penup;
    forward $width / 2;
    left 90;
    forward 10;
    text $_;
    pendown;
    restore;
    forward $width;
    }
  restore;
  }

sub run
  {
  penup;
  forward 50;
  right 90;
  forward 400;
  pendown;
  house(300);
  penup;
  forward 400;
  pendown;
  graph( 400, 2,7,4,5,1,8,6 );
  }
