#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Hexapawn
use warnings;
use List::AllUtils qw( max each_array reduce shuffle );
use Tk;

my @argv = @ARGV;
my $size = max 3, shift // 3;
my $train = shift // 1e3;
my $forward = qr/.{$size}/s;
my $take = qr/.{@{[$size - 1]}}(?:..)?/s;
my $message = 'Click on Pawn';
my (@played, %scores, $from, $active);
my $board = my $start = "b\n-\nw\n" =~
  s/-\n/$& x ($size - 2)/er =~ s/./$& x $size/ger;

my $mw = MainWindow->new;
$mw->geometry( '+600+300' );
$mw->title( 'RosettaCode Hexapawn' );
my $grid = $mw->Frame->pack;
my @squares = map {
  my $row = $_;
  map {
    my $col = $_;
    my $g = $grid->Canvas( -width => 100, -height => 100,
      -bd => 0, -relief => 'flat', -highlightthickness => 0,
      -bg => ($row+$col) % 2 ? 'gray80' : 'gray60',
      )->grid( -row => $row, -column => $col, -sticky => 'nsew' );
    $g->Tk::bind('<1>' => sub{ click( $col, $row ) } );
    $g->Tk::bind("<ButtonRelease-$_>" => sub{$g->yviewMoveto(0)} ) for 4, 5;
    $g } 0 .. $size - 1
  } 0 .. $size - 1;
my $label = $mw->Label( -textvariable => \$message,
  )->pack( -side => 'bottom', -expand => 1, -fill => 'both' );
$mw->Button(-text => 'Exit', -command => sub {$mw->destroy},
  )->pack( -side => 'right', -fill => 'x', -expand => 0 );
$mw->Button(-text => 'New Game', -command => \&newgame,
  )->pack( -side => 'right', -fill => 'x', -expand => 1 );
$mw->Button(-text => 'Train', -command => \&train,
  )->pack( -side => 'right', -fill => 'x', -expand => 0 );
newgame();
MainLoop;
-M $0 < 0 and exec "$0 @argv";

sub findwhite
  {
  my @moves;
  $board =~ /(?:-($forward)w|b($take)w)(?{ push @moves, "$`w$+-$'"; })(*FAIL)/;
  @moves;
  }

sub findblack
  {
  my @moves;
  $board =~ /(?:b($forward)-|b($take)w)(?{ push @moves, "$`-$+b$'"; })(*FAIL)/;
  @moves;
  }

sub newgame
  {
  $board = $start;
  @played = ();
  $from = undef;
  $active = 1;
  $message = 'Click on Pawn';
  $label->configure( -bg => 'gray85' );
  show();
  }

sub train
  {
  $message = 'Training';
  $label->configure( -bg => 'yellow' );
  $mw->update;
  for ( 1 .. $train )
    {
    $board = $start;
    my @whitemoves = findwhite;
    my @blackmoves;
    @played = ();
    while( 1 )
      {
      $board = $whitemoves[rand @whitemoves];;
      if( $board =~ /^.*w/ or not (@blackmoves = findblack) )
        {
        $scores{$_}++ for map {$_, s/.+/ reverse $& /ger } @played;
        last;
        }
      push @played, $board = $blackmoves[rand @blackmoves];
      if( $board =~ /b.*$/ or not (@whitemoves = findwhite) )
        {
        $scores{$_}-- for map {$_, s/.+/ reverse $& /ger } @played;
        last;
        }
      }
    }
  print "score count: @{[ scalar keys %scores ]}\n";
  newgame();
  }

sub scale { map 100 * $_ >> 3, @_ };

sub show
  {
  my $ea = each_array(@{[ $board =~ /./g ]}, @squares );
  while( my ($piece, $canvas) = $ea->() )
    {
    $canvas->delete('all');
    $piece eq '-' and next;
    $canvas->createOval(scale(3, 3, 5, 5));
    $canvas->createArc(scale(2, 4.8, 6, 9), -start => 0, -extent => 180);
    $canvas->itemconfigure('all', -outline => undef,
      -fill => $piece eq 'w' ? 'white' : 'black');
    }
  }

sub click
  {
  my ($col, $row) = @_;
  $active or return;
  my $pos = $row * ($size + 1) + $col;
  if( 'w' eq substr $board, $pos, 1 )
    {
    $from = $pos;
    $message = 'Click on Destination';
    }
  elsif( defined $from )
    {
    my $new = $board;
    substr $new, $from, 1, '-';
    substr $new, $pos, 1, 'w';
    if( grep $_ eq $new, findwhite )
      {
      $board = $new;
      my @blackmoves = findblack;
      if( $board =~ /^.*w/ or @blackmoves == 0 )
        {
        $active = 0;
        $message = 'White Wins';
        $label->configure( -bg => 'green' );
        $scores{$_}++ for map {$_, s/.+/ reverse $& /ger } @played;
        }
      else
        {
        $from = undef;
        $message = 'Blacks Move';
        push @played, $board = reduce
          { ($scores{$a} // 0) < ($scores{$b} // 0) ? $a : $b }
          shuffle @blackmoves;
        if( $board =~ /b.*$/ or not findwhite )
          {
          $active = 0;
          $message = 'Black Wins';
          $label->configure( -bg => 'red' );
          $scores{$_}-- for map {$_, s/.+/ reverse $& /ger } @played;
          }
        else
          {
          $message = 'Click on Pawn';
          }
        }
      show;
      }
    else
      {
      $mw->bell;
      $message = 'Invalid move';
      $mw->after( 500 => sub { $message = 'Click on Destination' } );
      }
    }
  }
