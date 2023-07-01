#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/2048
use warnings;
use Tk;

my $N = shift // 4;
$N < 2 and $N = 2;
my @squares = 1 .. $N*$N;
my %n2ch = (' ' => ' ');
@n2ch{ map 2**$_, 1..26} = 'a'..'z';
my %ch2n = reverse %n2ch;
my $winner = '';
my @arow = 0 .. $N - 1;
my @acol = map $_ * $N, @arow;

my $mw = MainWindow->new;
$mw->geometry( '+300+0' );
$mw->title( 2048 );
$mw->focus;
$mw->bind('<KeyPress-Left>' => sub { arrow($N, @arow) } );
$mw->bind('<KeyPress-Right>' => sub { arrow($N, reverse @arow) } );
$mw->bind('<KeyPress-Up>' => sub { arrow(1, @acol) } );
$mw->bind('<KeyPress-Down>' => sub { arrow(1, reverse @acol) } );
my $grid = $mw->Frame()->pack;
for my $i ( 0 .. $#squares )
  {
  $grid->Label(-textvariable => \$squares[$i],
    -width => 5, -height => 2, -font => 'courierbold 30',
    -relief => 'ridge', -borderwidth => 5,
    )->grid(-row => int $i / $N, -column => $i % $N );
  }
my $buttons = $mw->Frame()->pack(-fill => 'x', -expand => 1);
$buttons->Button(-text => 'Exit', -command => sub {$mw->destroy},
  -font => 'courierbold 14',
  )->pack(-side => 'right');
$buttons->Button(-text => 'New Game', -command => \&newgame,
  -font => 'courierbold 14',
  )->pack(-side => 'left');
$buttons->Label(-textvariable => \$winner,
  -font => 'courierbold 18', -fg => 'red2',
  )->pack;

newgame();
MainLoop;
-M $0 < 0 and exec $0;

sub losecheck
  {
  local $_ = join '', @n2ch{ @squares };
  / / || ($_ ^ substr $_, $N) =~ tr/\0// and return;
  /(.)\1/ and return for /.{$N}/g;
  $winner = 'You Lost';
  }

sub arrow
  {
  $winner and return;                                   # you won, no more play
  my ($inc, @ix) = @_;
  my $oldboard = "@squares";
  for ( 1 .. $N )
    {
    local $_ = join '', @n2ch{ @squares[@ix] };         # extract 4 squares
    tr/ //d;                                            # force left
    s/(\w)\1/ chr 1 + ord $1 /ge;                       # group by twos
    @squares[@ix] = @ch2n{ split //, $_ . ' ' x $N };   # replace
    $_ += $inc for @ix;                                 # next row or col
    }
  $oldboard eq "@squares" and return;
  add2();
  losecheck();
  grep $_ eq 2048, @squares and $winner = 'WINNER !!';
  }

sub add2
  {
  my @blanks = grep $squares[$_] eq ' ', 0 .. $#squares;
  @blanks and $squares[ $blanks[rand @blanks] ] =
    $_[0] // (rand() < 0.1 ? 4 : 2);
  }

sub newgame
  {
  $_ = ' ' for @squares;
  add2(2) for 1, 2;
  $winner = '';
  }
