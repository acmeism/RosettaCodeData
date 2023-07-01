#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Particle_fountain
use warnings;
use Tk;

my $size = 900;
my @particles;
my $maxparticles = 500;
my @colors = qw( red green blue yellow cyan magenta orange white );

my $mw = MainWindow->new;
my $c = $mw->Canvas( -width => $size, -height => $size, -bg => 'black',
  )->pack;
$mw->Button(-text => 'Exit', -command => sub {$mw->destroy},
  )->pack(-fill => 'x');

step();
MainLoop;
-M $0 < 0 and exec $0;

sub step
  {
  $c->delete('all');
  $c->createLine($size / 2 - 10, $size, $size / 2, $size - 10,
    $size / 2 + 10, $size, -fill => 'white' );
  for ( @particles )
    {
    my ($ox, $oy, $vx, $vy, $color) = @$_;
    my $x = $ox + $vx;
    my $y = $oy + $vy;
    $c->createRectangle($ox, $oy, $x, $y, -fill => $color, -outline => $color);
    if( $y < $size )
      {
      $_->[0] = $x;
      $_->[1] = $y;
      $_->[3] += 0.006; # gravity :)
      }
    else { $_ = undef }
    }
  @particles = grep defined, @particles;
  if( @particles < $maxparticles and --$| )
    {
    push @particles, [ $size >> 1, $size - 10,
      (1 - rand 2) / 2.5 , -3 - rand 0.05, $colors[rand @colors] ];
    }
  $mw->after(1 => \&step);
  }
