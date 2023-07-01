#!/usr/bin/perl

use strict; # http://www.rosettacode.org/wiki/Matrix_Digital_Rain
use warnings;
use Tk;
use List::Util qw( shuffle );

my ($rows, $cols) = (20, 40);
my @text = shuffle 'a'..'z', 'A'..'Z';
my $n = 0;

my $mw = MainWindow->new;
$mw->geometry( '+850+300' );
my $c = $mw->Canvas( -width => $cols * 10, -height => $rows * 20,
  -bg => 'black',
  )->pack;
$c->Tk::bind('<ButtonRelease-1>' => sub { $mw->destroy } );

my @queue = [ 100, 0, 255, 'A' ]; # [ x, y, color, letter ]
$mw->after( 5, \&step );
MainLoop;

sub step
  {
  $c->delete('all');
  my @new = [ 10 * int rand $cols, 0, 255, $text[++$n % @text] ];
  for ( @queue )
    {
    my $color = $_->[2] == 255 ? '#ffffff' : sprintf '#00%02x00', $_->[2];
    $c->createText($_->[0], $_->[1],
      -font => '10x20', -text => $_->[3], -fill => $color );
    $_->[2] == 255 and push @new, [ $_->[0], $_->[1] + 20, 255, $_->[3] ];
    $_->[2] -= 13;
    }
  @queue = grep $_->[2] > 0 && $_->[1] < $rows * 20, @queue, @new;
  $mw->after( 63, \&step );
  }
