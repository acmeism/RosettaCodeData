#!/usr/bin/perl

use strict;
use warnings;
use Tk;

my $active = 0;
my $bpm = 60;
my $x = 100;

my $mw = MainWindow->new;
$mw->title( "Metronome" );
my $c = $mw->Canvas(
  )->pack(-fill => 'both', -expand => 1);
$mw->Scale( -orient => 'horizontal', -from => 30, -to => 150,
  -variable => \$bpm, -label => 'Beats per Minute',
  )->pack(-fill => 'x');
$mw->Button( -text => 'Exit', -command => sub {$mw->destroy},
  )->pack(-side => 'right');
$mw->Button( -text => 'Start / Pause', -command => sub {$active ^= 1; tick()},
  )->pack(-side => 'right');
$mw->bind('<Configure>' => sub {$x = $c->width >> 2} );

MainLoop;

sub tick
  {
  $active or return;
# $mw->bell;
  $x *= -1;
  $c->delete('all');
  $c->createLine( $c->width >> 1, $c->height, $c->width / 2 + $x, 30,
    -width => 5);
  $mw->after( 60_000 / $bpm / 2 => \&tick );
  }
