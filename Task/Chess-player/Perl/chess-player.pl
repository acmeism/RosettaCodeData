#!/usr/bin/perl

use strict;
use warnings;
use Tk;
use Tk::ROText;
use List::Util qw( any sum0 shuffle first );

my $startingposition = our $board = <<END;
rnbqkbnr
pppppppp
--------
--------
--------
--------
PPPPPPPP
RNBQKBNR
END

my $size = 80;
my $message = 'Initializing...';
my ($from, $moving, $over);
my (%legal, %canmove, @previous, $castleleft, $castleright, $enpassant);
my @location = map { my $row = $_; map "$_$row", 'a' .. 'i' } reverse 1 .. 8;
my %values = qw( - 0 p 100 n 350 b 350 r 525 q 1e3 k 1e4);
my %names = qw(p pawn r rook n knight b bishop q queen k king);
our @moves;

my $g = qr/.{8}/s;
my $gm = qr/.{9}/s;
my $gp = qr/.{7}/s;
my $gpp = qr/.{6}/s;

my $opp = qr/[a-z]/;
my $oppe = qr/[a-z-]/;
my $whitemoves = qr/(?|
    (?| # forward
      (Q|R) (?: -* | $g (?:- $g)* ) ($oppe) # rectangular
    | (Q|B) (?: $gp (?:- $gp)* | $gm (?:- $gm)* ) ($oppe) # diagonal
    | (K) (?: | $gp | $g | $gm ) ($oppe)
    | (N) (?: $gm . $g | $gp . $g | . $gm | $gpp (?=..) ) ($oppe)
    ) (?{ push @moves, [$1, @-[1,2], $2] })
  |
    (?| # backward
      ($oppe) (?: -* | $g (?:- $g)* ) (Q|R) # rectangular
    | ($oppe) (?: $gp (?:- $gp)* | $gm (?:- $gm)* ) (Q|B) # diagonal
    | ($oppe) (?: | $gp | $g | $gm ) (K)
    | ($oppe) (?: $gm . $g | $gp . $g | . $gm | $gpp (?=..) ) (N)
    | (-) $g (P)
    | ($opp) (?: $gm | $gp ) (P)
    ) (?{ push @moves, [$2, @-[2,1], $1] })
  |
    (-) $g (-) $g (P) .*\n.{8}$ (?{ push @moves, [$3, @-[3,1], $1, $-[2]] })
  ) (*FAIL) /x;

$opp = qr/[A-Z]/;
$oppe = qr/[A-Z-]/;
my $blackmoves = qr/(?|
    (?| # forward
      (q|r) (?: -* | $g (?:- $g)* ) ($oppe) # rectangular
    | (q|b) (?: $gp (?:- $gp)* | $gm (?:- $gm)* ) ($oppe) # diagonal
    | (k) (?: | $gp | $g | $gm ) ($oppe)
    | (n) (?: $gm . $g | $gp . $g | . $gm | $gpp (?=..) ) ($oppe)
    | (p) $g (-)
    | (p) (?: $gm | $gp ) ($opp)
    ) (?{ push @moves, [$1, @-[1,2], $2] })
  |
    ^.{8}\n.* (p) $g (-) $g (-) (?{ push @moves, [$1, @-[1,3], $3, $-[2]] })
  |
    (?| # backward
      ($oppe) (?: -* | $g (?:- $g)* ) (q|r) # rectangular
    | ($oppe) (?: $gp (?:- $gp)* | $gm (?:- $gm)* ) (q|b) # diagonal
    | ($oppe) (?: | $gp | $g | $gm ) (k)
    | ($oppe) (?: $gm . $g | $gp . $g | . $gm | $gpp (?=..) ) (n)
    ) (?{ push @moves, [$2, @-[2,1], $1] })
  ) (*FAIL) /x;

my $mw = MainWindow->new;
$mw->title( 'Chess' );
my $label = $mw->Label( -textvariable => \$message, -font => 'times 20',
  )->pack(-fill => 'x');
$mw->Frame(-height => 20, -bg => 'darkblue',
  )->pack(-fill => 'x', -expand => 1);
my $grid = $mw->Frame->pack;
my @squares = map { my $me = $_; $_ % 9 == 8 ? 'oops' :
  do { my $w = $grid->Canvas( -width => $size, -height => $size,
    -bd => 0, -relief => 'flat', -highlightthickness => 0,
    -bg => ($_ % 9 + int $_ / 9) % 2 ? 'brown3' : 'brown2',
    )->grid( -row => 1 + int $_ / 9, -column => 1 + $_ % 9 );
    $w->Tk::bind('<ButtonRelease-4>' => sub{$w->yviewMoveto(0)} );
    $w->Tk::bind('<ButtonRelease-5>' => sub{$w->yviewMoveto(0)} );
    $w->Tk::bind('<1>' => sub { click($me) } );
    $w }
  } 0 .. 71;
for my $n (0 .. 7)
  {
  $grid->Label(-text => $n + 1,
    )->grid( -row => 8 - $n, -column => $_) for 0, 9;
  $grid->Label(-text => ('a' ... 'h')[$n],
    )->grid( -row => $_, -column => 1 + $n) for 0, 9;
  }
$mw->Frame(-height => 20, -bg => 'darkblue',
  )->pack(-fill => 'x', -expand => 1);
$mw->Button(-text => $_->[0], -command => $_->[1], -font => 24,
  )->pack( -side => 'left', -fill => 'x', -expand => 1) for
    [Restart => \&restart],
    ['Previous State' => \&previous],
    ['Random Move' => \&random],
    [Help => \&help],
    [Exit => sub {$mw->destroy}];

restart();

MainLoop;
-M $0 < 0 and exec $0, @ARGV;

sub restart
  {
  $from = $over = undef;
  $enpassant = -1;
  $castleleft = $castleright = 1;
  @previous =
    [ ($board = $startingposition), $castleleft, $castleright, $enpassant ];
  show( $board );
  $message = (incheck($board, 1) && "** IN CHECK ** ") . 'White to move';
  $label->configure(-bg => 'gray85');
  $label->configure(-fg => 'black');
  findlegal();
  }

sub previous
  {
  $over and $mw->bell, return;
  @previous and ($board, $castleleft, $castleright, $enpassant) =
    @{ pop @previous };
  show($board);
  findlegal();
  }

sub random
  {
  $over || keys %legal == 0 and $mw->bell, return;
  ($from, my $to) = split ' ', (keys %legal)[rand keys %legal];
# ($from, my $to) = map @$_,
#   (sort { $values{substr $board, $b->[1], 1} <=>
#     $values{substr $board, $a->[1], 1} }
#   map [ split ],
#   shuffle keys %legal)[0];
  $moving = substr $board, $from, 1;
  click($to);
  }

sub click
  {
  $over and $mw->bell, return;
  my $pos = shift;
  my $piece = substr $board, $pos, 1;
  if( defined $from )
    {
    if( $piece eq 'R' and $legal{"$from $pos"} and $from == 67 and
      $pos == 63 || $pos == 70 ) # castle
      {
      push @previous, [ $board, $castleleft, $castleright, $enpassant ];
      $pos == 63 ? $board =~ s/R---K/--KR-/ : $board =~ s/K--R/-RK-/;
      $castleright = $castleleft = 0;
      playblack();
      }
    elsif( $pos == $enpassant and $piece eq '-' and
      $from == $enpassant + 8 and substr($board, $from, 1) eq 'P' )
      {
      substr($board, $enpassant, 10) =~ s/-(.{7})Pp/P$1--/s
        or die "enpassant";
      $enpassant = -1;
      playblack();
      }
    elsif( $pos == $enpassant and $piece eq '-' and
      $from == $enpassant + 10 and substr($board, $from, 1) eq 'P' )
      {
      substr($board, $enpassant, 11) =~ s/-(.{8})pP/P$1--/s
        or die "enpassant";
      $enpassant = -1;
      playblack();
      }
    elsif( $piece =~ /[a-z-]/ and $legal{"$from $pos"} )
      {
      push @previous, [ $board, $castleleft, $castleright, $enpassant ];
      substr $board, $from, 1, '-';
      substr $board, $pos, 1, $moving;
      1 while $board =~ s/^.*\KP/Q/; # promotion
      $board =~ s/p(?=.*$)/q/g; # promotion
      $from == 67 and $castleleft = $castleright = 0; # no castle king
      $from == 63 and $castleleft = 0; # left rook
      $from == 70 and $castleright = 0; # right rook
      playblack();
      }
    else { $mw->bell }
    $from = $piece = undef;
    if( not $over )
      {
      $message = 'White to move';
      $label->configure(-bg => 'gray85');
      findlegal();
      if( ! $over and incheck($board, 1) )
        {
        $message =~ s/^/** IN CHECK ** /;
        $label->configure(-bg => 'yellow');
        }
      }
    show($board);
    }
  elsif( $piece =~ /[A-Z]/ and $canmove{$pos} )
    {
    $from = $pos;
    $moving = $piece;
    $message = "White moving $names{lc $moving} from $location[$from]";
    $squares[$from]->itemconfigure('all', -fill => 'yellow');
    }
  else
    {
    $piece =~ /[A-Z]/ and $mw->bell;
    $from = $piece = undef;
    findlegal();
    $message = 'White to move';
    show($board);
    }
  }

sub scale { map $size * $_ >> 3, @_ };

sub show
  {
  while( $board =~ /./g )
    {
    my $c = $squares[ my $pos = $-[0] ];
    my $char = uc $&;
    my $color = $& =~ /[A-Z]/ ? 'white' : 'black';
    $c->delete('all');
    if( $char eq 'P' )
      {
      $c->createOval(scale(3, 3, 5, 5));
      $c->createArc(scale(2, 4.8, 6, 9), -start => 0, -extent => 180);
      $c->itemconfigure('all', -outline => undef);
      }
    elsif( $char eq 'N' )
      {
      $c->createPolygon( scale(2, 7, 1, 4, 3, 1, 7, 4, 6, 5, 4, 4, 5.5, 7));
      }
    elsif( $char eq 'K' )
      {
      $c->createPolygon( scale(1, 7, 3.5, 4, 3.5, 3, 2.5, 3, 2.5,
        2, 3.5, 2, 3.5, 1, 4.5, 1, 4.5, 2, 5.5, 2, 5.5, 3, 4.5, 3, 4.5,
        4, 7, 7));
      $c->createArc( scale(1, 4, 4, 10), -start => 60, -extent => 120,
        -outline => undef);
      $c->createArc( scale(4, 4, 7, 10), -start => 0, -extent => 120,
        -outline => undef);
      }
    elsif( $char eq 'Q' )
      {
      $c->createPolygon( scale(2, 7, 1, 2, 3, 5, 4, 1, 5, 5, 7, 2, 6, 7));
      }
    elsif( $char eq 'R' )
      {
      $c->createPolygon( scale(1, 7, 2, 3, 1, 3, 1, 1,
        2, 1, 2, 2, 3, 2, 3, 1, 5, 1, 5, 2, 6, 2, 6, 1,
        7, 1, 7, 3, 6, 3, 7, 7));
      }
    elsif( $char eq 'B' )
      {
      $c->createPolygon(scale(3, 7, 2, 6, 4, 1, 6, 6, 5, 7));
      $c->createOval(scale(3.5, 1, 4.5, 2), -outline => undef);
      }
    $c->itemconfigure('all', -fill => $color);
    }
  }

sub newboard
  {
  my ($piece, $from, $to, $was) = @{ +shift };
  my $newboard = $board;
  substr $newboard, $from, 1, '-';
  substr $newboard, $to, 1, $piece;
  $newboard;
  }

sub incheck # board, 1=whiteincheck 0=blackincheck
  {
  my ($newboard, $who) = @_;
  local @moves;
  $newboard =~ ( $who ? $blackmoves : $whitemoves );
  any { $_->[3] =~ /k/i } @moves;
  }

sub blink
  {
  my $pos = shift;
  $message = 'Black moving...';
  for ( ('green', 'red') x 2 )
    {
    $squares[$pos]->itemconfigure('all', -fill => $_);
    $mw->update;
    select undef, undef, undef, 0.1;
    }
  }

sub findlegal
  {
  local @moves;
  $board =~ $whitemoves;
  %legal = %canmove = ();
  $legal{ $_->[1] . ' ' . $_->[2] } = $canmove{$_->[1]} = 1 for
    grep { ! incheck(newboard($_), 1) } @moves;
  @moves = ();
  if( $castleleft and $board =~ /R---K...\n\z/ )
    {
    $board =~ $blackmoves;
    my $attack = any { $_->[2] =~ /6[567]/ } @moves;
    $attack or $legal{"67 63"} = $canmove{67} = 1;
    }
  if( $castleright and $board =~ /K--R\n\z/ )
    {
    @moves or $board =~ $blackmoves;
    my $attack = any { $_->[2] =~ /6[789]/ } @moves;
    $attack or $legal{"67 70"} = $canmove{67} = 1;
    }
  if( $enpassant > 0 )
    {
    substr($board, $enpassant + $_, 1) eq 'P' and
      $legal{$enpassant + $_ . " $enpassant"} = $canmove{$enpassant + $_} = 1
      for 8, 10;
    }
  if( not %legal )
    {
    $over = 1;
    $message = incheck($board, 1) ? "CHECKMATE" : "DRAW";
    $label->configure(-bg => 'red');
    $label->configure(-fg => 'white');
    }
  }

sub islegal { $legal{"@_"} }

sub score
  {
  my $bb = newboard(shift);
  sum0 map(-$values{+lc}, $bb =~ /[A-Z]/g), map $values{$_}, $bb =~ /[a-z]/g;
  }

sub lookahead
  {
  my $bb = shift;
  local @moves;
  $bb =~ $blackmoves;
# print "black moves : " . @moves, "\n";
  my @bbest;
  for my $bmove ( @moves )
    {
    my $freedom;
    local $board = newboard($bmove);
    local @moves;
    $board =~ $whitemoves;
    $freedom = @moves;
    my @wbest;
    for my $wmove ( @moves )
      {
      local $board = newboard($wmove);
      local @moves;
      $board =~ $blackmoves;
      my @bbest2;
      for my $bmove2 ( @moves )
        {
        push @bbest2, [ $bmove, score($bmove2), $freedom ];
        }
      push @wbest, first { not incheck( newboard($wmove, 0) ) }
        sort { $b->[1] <=> $a->[1] } shuffle @bbest2;
      }
    push @bbest, first { not incheck( newboard($bmove, 1) ) }
      sort { $a->[1] <=> $b->[1] }
      grep defined $_->[1],
      shuffle @wbest;
    }
  map $_->[0], sort { $b->[1] <=> $a->[1] or $b->[2] <=> $a->[2] }
    grep defined $_->[1],
    shuffle @bbest;
  }

sub playblack
  {
  show($board);
  $message = 'Black thinking...';
  $label->configure(-bg => 'gray85');
  $mw->update;
  @moves = lookahead($board);
  my $themove = first { ! incheck(newboard($_), 0) } @moves;
  if( not $themove )
    {
    $over = 1;
    $message = incheck( $board, 0 ) ? "CHECKMATE" : "DRAW";
    $label->configure(-bg => 'red');
    $label->configure(-fg => 'white');
    return;
    }
  blink( $themove->[1] );
  $board = newboard $themove;
  $enpassant = $themove->[4] // -1;
  1 while $board =~ s/^.*\KP/Q/;
  $board =~ s/p(?=.*$)/q/g;
  show($board);
  }

sub help
  {
  my $help = $mw->Toplevel;
  $help->title("Chess Help");
  my $ro = $help->ROText( -font => 'times 14', -height => 12, -width => 60,
    )->pack;
  $help->Button(-text => 'Dismiss', -command => sub {$help->destroy},
    )->pack(-fill => 'x');
  $ro->insert(end => <<END);

You are playing White, the program is playing Black.

To move or capture : left click on piece to move,
   it should turn yellow if a legal move for that piece exists,
   then left click on the destination square.

To castle : left click on the King, then left click on a Rook.

To capture "en passant" : left click on your Pawn,
   then left click on the square the opponent's Pawn skipped over.
END
  }
