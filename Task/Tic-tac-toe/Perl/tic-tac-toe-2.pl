#!/usr/bin/perl

use strict;
use warnings;
use Tk;
use List::Util qw( shuffle );

my $win = qr/(?| ^(\w)...\1...\1 | ^..(\w).\1.\1   # diagonals
  | ^(?:...)*?(\w)\1\1 | (\w)..\1..\1 )/x;         # row or column
my (%cache, $message, $game);

my $mw = MainWindow->new( -title => 'TicTacToe' );
$mw->geometry('+1000+300');
$mw->Label(-textvariable => \$message, -font => 'courierbold 16',
  )->pack(-fill => 'x');
my $grid = $mw->Frame( -borderwidth => 5, -relief => 'ridge' )->pack;
$mw->Button(-text => $_->[0], -command => $_->[1],
  )->pack(-side => 'left', -fill => 'x', -expand => 1) for
  ['Restart X first' => sub { restart(1) }],
  ['Restart O first' => sub { restart(0) }],
  [           'Exit' => sub { $mw->destroy }];
my @cells = map { my $me = $_;
  $grid->Button( -command => sub { person($me) },
    -width => 1, -height => 1, -font => 'courierbold 40',
    )->grid(-row => int $_ / 3, -column => $_ % 3)
  } 0 .. 8;

restart(1);

MainLoop;

sub show { $cells[$_]->configure(-text => substr $game, $_, 1) for 0 .. 8 }

sub person
  {
  $message =~ /O's turn/ or return;
  pos($game) = shift();
  if( $game =~ s/\G /O/ )
    {
    $message = $game =~ $win ? "O Wins" :
      $game !~ / / ? "Draw" : do {
        $game = move( $game, 'X' )->[1];
        $game =~ $win ? 'X Wins' :
          $game !~ / / ? 'Draw' : "O's turn to move"
      };
    show;
    }
  }

sub restart
  {
  %cache = ();
  $game = shift() ? move( ' ' x 9, 'X' )->[1] : ' ' x 9;
  show;
  $message = "O's turn to move";
  }

sub move
  {
  (local $_, my $who, my @moves) = @_;
  /$win/ and return [ 2 * ($1 eq 'X'), $_ ];
  / / or return [ 1, $_ ];
  $cache{$_ . $who} //= do
    {
    while( / /g )
      {
      my $move = "$`$who$'";
      push @moves, [ move($move, $who ^ 'X' ^ 'O')->[0], $move ];
      }
    (sort {$a->[0] <=> $b->[0]} shuffle @moves)[ -($who eq 'X') ]
    };
  }
