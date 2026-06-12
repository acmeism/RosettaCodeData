#!/usr/bin/perl

use strict; # http://www.rosettacode.org/wiki/16_Puzzle_Game
use warnings;
use List::Util qw( any );
use Tk;

my $size = $ARGV[0] // 4;
my $width = length $size ** 2;
my $message = '';
my $steps;
my @board;
my @again;
my $easy = 3;

my $mw = MainWindow->new( -title => '16 Puzzle in Tk' );
$mw->geometry( '+470+300' );
$mw->optionAdd('*font' => 'sans 14');
my $frame = $mw->Frame(-bg => 'gray', -relief => 'ridge',
  -borderwidth => 5)->pack;
my $label = $mw->Label( -textvariable => \$message, -font => 'times-bold 30',
  )->pack;
$mw->Button( -text => "Exit", -command => sub {$mw->destroy},
  )->pack(-side => 'right');
$mw->Button( -text => "Reset", -command => sub {
  @board = @again;
  show();
  $message = $steps = 0;
  $label->configure(-fg => 'black');
  },)->pack(-side => 'right');
$mw->Button( -text => "Easy", -command => sub {$easy = 3; generate()},
  )->pack(-side => 'left');
$mw->Button( -text => "Hard", -command => sub {$easy = 12; generate()},
  )->pack(-side => 'left');

my @cells = map {
  $frame->Label(-text => $_, -relief => 'sunken', -borderwidth => 2,
    -fg => 'white', -bg => 'blue', -font => 'sans 24',
    -padx => 7, -pady => 7, -width => $width,
    )->grid(-row => int( $_ / $size + 2 ), -column => $_ % $size + 2,
    -sticky => "nsew",
  ) } 0 .. $size ** 2 - 1;

for my $i (1 .. $size)
  {
  $frame->Button(-text => ">", -command => sub {move("R$i") },
    )->grid(-row => $i + 1, -column => 1, -sticky => "nsew");
  $frame->Button(-text => "<", -command => sub {move("L$i") },
    )->grid(-row => $i + 1, -column => $size + 2, -sticky => "nsew");
  $frame->Button(-text => "v", -command => sub {move("D$i") },
    )->grid(-row => 1, -column => $i + 1, -sticky => "nsew");
  $frame->Button(-text => "^", -command => sub {move("U$i") },
    )->grid(-row => $size + 2, -column => $i + 1, -sticky => "nsew");
  }

generate();

MainLoop;
-M $0 < 0 and exec $0, @ARGV; # restart if source file modified since start

sub randommove { move( qw(U D L R)[rand 4] . int 1 + rand $size ) }

sub show { $cells[$_]->configure(-text => $board[$_]) for 0 .. $size ** 2 - 1 }

sub success { not any { $_ + 1 != $board[$_] } 0 .. $size ** 2 - 1 }

sub move
  {
  my ($dir, $index) = split //, shift;
  $index--;
  my @from = map {
    $dir =~ /L|R/i ? $_ + $size * $index : $_ * $size + $index
    } 0 .. $size - 1;
  @board[@from] = (@board[@from])[ ($dir =~ /L|U/i || -1) .. $size - 1, 0 ];
  show();
  $message = ++$steps;
  $label->configure(-fg => success() ? 'red' : 'black');
  success() and $message = "Solved in $steps";
  }

sub generate
  {
  @board = 1 .. $size ** 2;
  randommove() for 1 .. 1 + int rand $easy;
  success() and randommove();
  @again = @board;
  $message = $steps = 0;
  }
