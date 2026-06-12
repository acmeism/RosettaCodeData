#!/usr/bin/perl

use strict;
use warnings;
use Tk;
use List::Util qw( shuffle );

my (@buttons, $pressed);
my $mw = MainWindow->new;
$mw->geometry( '+800+300' );
$mw->title( 'Number Triplets Game - RosettaCode' );
my $grid = $mw->Frame->pack;
for my $row ( 0 .. 4 )
  {
  for my $col ( 0 .. 8 )
    {
    my $color = $row ? $col & 1 ?
      'yellow' : 0 < $col < 8 ? 'white' : 'black' : 'blue';
    push @buttons, [ $grid->Button(-text => ' ',
      -bg => $color, -fg => 'white',
      -width => 2, -height => 2, -font => 'timesbold 20',
      -command => sub { press($row * 10 + $col) },
      )->grid(-row => $row, -column => $col), $color, 0, $row * 10 + $col ];
    }
  push @buttons, [0, 'green', 0];
  }
$mw->Button(-text => 'New Game', -command => \&newgame, -height => 2,
  -bg => 'black', -fg => 'magenta', -font => 'timesbold 20',
  )->pack(-fill => 'x');

newgame();
MainLoop;

sub reach
  {
  my $button = shift;
  my $field = join '', map { $_->[0] ? $_->[2] ? $_->[2] :
    $_->[1] =~ /blue|yellow/ ? ' ' : '#': "\n" } @buttons;
  substr $field, $button->[3], 1, '-';
  1 while $field =~ s/-(|.{9}) | (|.{9})-/-$+-/s;
  $_->[0] and $_->[0]->configure(-state => $_->[2] ||
    substr($field, $_->[3], 1) eq '-' ? 'normal' : 'disabled') for @buttons;
  }

sub press
  {
  my ($n) = @_;
  my $button = $buttons[$n];
  if( $button->[2] ) # has number, change selected
    {
    reach( $pressed = $button );
    }
  else # swap
    {
    $button->[2] = $pressed->[2];
    $pressed->[2] = 0;
    $button->[0]->configure(-bg => 'red3', -text => $button->[2]);
    $pressed->[0]->configure(-bg => $pressed->[1], -text => ' ');
    reach( $pressed = $button );
    }
  }

sub newgame
  {
  $_->[0] && $_->[0]->configure(-bg => $_->[1], -text => ' ',
    -state => 'disabled'), $_->[2] = 0, for @buttons; # clear
  my @valid = shuffle grep $_->[1] =~ /blue|yellow/, @buttons;
  $valid[0][0]->configure(-bg => 'red3', -text => $_, -state => 'normal'),
    $valid[0][2] = $_, shift @valid for qw(1 2 3 4) x 3;
  }
