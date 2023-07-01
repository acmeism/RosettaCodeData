#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Fibonacci_word
use warnings;
use Tk;

my @fword = ( 1, 0 );
push @fword, $fword[-1] . $fword[-2] for 1 .. 21;
#use Data::Dump 'dd'; dd@fword;

my $mw = MainWindow->new;
my $c = $mw->Canvas( -width => 1185, -height => 860,
  )->pack;
$mw->Button(-text => 'Exit', -command => sub {$mw->destroy},
  )->pack(-fill => 'x', -side => 'right');
$mw->Button(-text => 'Redraw', -command => sub {draw($fword[-1])},
  )->pack(-fill => 'x', -side => 'right');

$mw->update;
draw($fword[-1]);

MainLoop;
-M $0 < 0 and exec $0;

sub draw
  {
  $c->delete('all');
  my $string = shift;
  my ($x, $y) = ($c->width - 20, $c->height - 20);
  my ($dx, $dy) = (0, -2);
  my $count = 0;
  for my $ch ( split //, $string )
    {
    my ($nx, $ny) = ($x + $dx, $y + $dy);
    $c->createLine($x, $y, $nx, $ny);
    $mw->update;
    ($x, $y) = ($nx, $ny);
    $count++;
    $ch or ($dx, $dy) = $count % 2 ? ($dy, -$dx) : (-$dy, $dx);
    }
  }
