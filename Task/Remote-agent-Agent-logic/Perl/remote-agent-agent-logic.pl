#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Remote_agent
use warnings;
use IO::Socket;
use List::Util qw( shuffle first );
use Time::HiRes qw( sleep time );
$SIG{__WARN__} = sub { die @_ };
$/ = '.';
$| = 1;
my $delay = 0;
my $show = 1;

my $server = shift // 'localhost:3141';
my $socket = IO::Socket::INET->new($server) or die $@;
getc $socket eq 'A' ? print $socket 'A' : die "no handshake";
my $start = time;

my ($wide, $high) = (3, 3);
my $grid = ('  ' x $wide . " \n") x $high;
my $gap = $wide * 2 + 2;
my %gap = ( N => -$gap, E => 2, S => $gap, W => -2 );
my $dir = 'N';
my $agent = $gap * ($high >> 1) + 2 * ($wide >> 1);
my @wrong = map { my $f = $_;
  map { $f eq $_ ? () : "$f\l$_" } qw(R G B Y) } qw(R G B Y);
my $wrong = qr/(?:@{[ join '|', @wrong ]})/;
my $success = '';
my $turns = 0;
$show and print "\e[H\e[J";

sub show
  {
  $show and print "\e[H$grid\n" =~ s/([RGBY])([rgby])/ $1 eq uc $2 ?
    "\e[92m$1$2\e[m" : "\e[91m$1$2\e[m" /ger =~ s/[RGBY] /\e[94m$&\e[m/gr;
  }

sub out { substr $grid, $agent, 2, shift }

sub at { substr $grid, shift, 2 }

sub command
  {
  $turns += print $socket @_;
  local $_ = <$socket>;
  /\|/ or $turns++;
  $_;
  }

sub set # sends command to rotate from current dir to requested dir
  {
  my $want = shift;
  $want =~ /^[NESW]$/ or die "bad dir $want";
  $want eq $dir and return;
  command $_ for split //,
    'NESWN' =~ /$dir$want/ ? '>' : 'NWSEN' =~ /$dir$want/ ? '<' : '>>';
  $dir = $want;
  }

sub expand # the grid if color sector on edge
  {
  if( $grid =~ /\w.*$/ )
    {
    $grid .= '  ' x $wide . " \n";
    $high += 1;
    }
  elsif( $grid =~ /^.*\w/ )
    {
    $grid = '  ' x $wide . " \n" . $grid;
    $agent += 2 * ($wide + 1);
    $high += 1;
    }
  elsif( $grid =~ /^\w/m )
    {
    my $lines = $` =~ tr/\n//;
    $grid =~ s/^/  /gm;
    $agent += 2 * (1 + $lines);
    $wide++;
    }
  elsif( $grid =~ /\w. \n/ )
    {
    my $lines = $` =~ tr/\n//;
    $grid =~ s/\n/  \n/g;
    $agent += 2 * $lines;
    $wide++;
    }
  $gap = 2 * ($wide + 1); # if changed vertical step
  %gap = ( N => -$gap, E => 2, S => $gap, W => -2 );
  }

sub moveto
  {
  my ($to) = @_;
  $agent == $to and return;
  my $bloc = $agent >> 1;
  local $_ = $grid =~ s/(.).| (\n)/$+/gr;
  tr/RGBY |/    -/;
  substr $_, $to >> 1, 1, 'd';
  my $gap = /\n/ && $-[0];
  substr $_, $bloc, 1, ' ';
  while( ' ' eq substr $_, $bloc, 1 )
    {
    my $west = ((tr/-/ /r =~ s/(.*)./ $1/gr | $_) &
      tr/dnesw /     \xff/r) =~ tr/a-\x7f/w/r;
    my $east = ((tr/-/ /r =~ s/.(.*)/$1 /gr | $_) &
      tr/dnesw /     \xff/r) =~ tr/a-\x7f/ e/r;
    my $south = ((substr($_, $gap + 1) =~ tr/-/ /r | $_) &
      tr/dnesw /     \xff/r) =~ tr/a-\x7f/ s/r;
    my $north = (((' ' x $gap . "\n" . substr($_, 0, -$gap - 1)) =~
      tr/-/ /r | $_) & tr/dnesw /     \xff/r) =~ tr/a-\x7f/ n/r;
    $_ = ($_ & $south =~ tr/ w/\xff\0/r) | $south;
    $_ = ($_ & $north =~ tr/ w/\xff\0/r) | $north;
    $_ = ($_ & $west =~ tr/ w/\xff\0/r) | $west;
    $_ = ($_ & $east =~ tr/ w/\xff\0/r) | $east;
    "$east$west$north$south" =~ /\w/ or die "d not found";
    }
  my $path = '';
  my %gap = (N => -$gap - 1, S => $gap + 1, E => 1, W => -1);
  while( 1 )
    {
    my $dir = uc substr $_, $bloc, 1;
    $dir =~ /[NESW]/ or last;
    $path .= $dir;
    $bloc += $gap{$dir};
    }
  set($_), $_ = command( '^' ), /[|]/ && die "wall during moveto"
    for split //, $path; # walk agent along path
  $agent = $to; # arrived
  }

while( $grid =~ /  / ) ############################################  main
  {
  show;
  $delay and sleep $delay;
  $agent % 2 and die "$agent is odd";
  my $v = qr/(?:..){$wide}/s;
  if( $grid =~ /[RGBY]/ )
    {
    my ($in, $face) =
      at( $agent - 2 ) eq '  ' ? ($agent, 'W') :
      at( $agent + $gap{'N'} ) eq '  ' ? ($agent, 'N') :
      at( $agent + $gap{'S'} ) eq '  ' ? ($agent, 'S') :
      at( $agent + 2 ) eq '  ' ? ($agent, 'E') :
      $grid =~ /  ([RGBY].)/ ? ($-[1], 'W') :
      $grid =~ /([RGBY].)  / ? ($-[1], 'E') :
      $grid =~ /  $v([RGBY].)/ ? ($-[1], 'N') :
      $grid =~ /([RGBY].)$v  / ? ($-[1], 'S') : last;
    moveto($in);
    set($face);
    $_ = command '^';
    if( /\|/ ) { substr $grid, $agent + $gap{$dir}, 2, '||'; }
    else
      {
      $agent += $gap{$dir};
      out tr/RGBY//cdr . (tr/rgby//cdr || ' ');
      expand();
      }
    }
  else
    {
    substr($grid, $agent + $gap{$dir}, 2, '||'),
      set('NESWN' =~ /$dir(.)/ ? $1 : die "bad dir")
      while $_ = command('^'), /\|/;
    $agent += $gap{$dir};
    out tr/RGBY//cdr . (tr/rgby//cdr || ' ');
    expand();
    }
  }
show;
tr/R// >= tr/r// && tr/G// >= tr/g// && tr/B// >= tr/b// && tr/Y// >= tr/y//
  && tr/RGBY// > tr/rgby// or die "invalid ball counts" for $grid;
#$grid =~ /$wrong/ ? print "swapping\n" : print "no swapping needed";

sub any
  {
  my ($qr) = @_;
  my @any;
  push @any, $-[0] while $grid =~ /$qr/g;
  $any[rand @any];
  }

sub dist
  {
  my ($x, $y) = map $_ >> 1, @_;
  my $w = $wide + 1;
  abs($x % $w - $y % $w) + abs(int($x / $w) - int($y / $w));
  }

sub nearest
  {
  my ($qr, $from) = @_;
  my @dist;
  $dist[dist( $from, $-[0] )] = $-[0] while $grid =~ /$qr/g;
  first {defined} @dist;
  }

while( 1 )
  {
  show;
  my $from = nearest( qr/$wrong/, $agent ) or last;
  my $ball = substr $grid, $from + 1, 1;
  $grid =~ /\u$ball / or $from = any( qr/$wrong/ ),
    $ball = substr $grid, $from + 1, 1;
  my $to = nearest( qr/\u$ball /, $from ) || any( qr/[RGBY] / );
# my $to = ( $grid =~ /\u$ball / && $-[0] ) || any( qr/[RGBY] / );
  moveto($from);
  $_ = command '@';
  /[as]/i and die "ERROR $_ on get";
  substr $grid, $from + 1, 1, ' ';
  moveto($to);
  $_ = command '!';
  /[as]/i and die "ERROR $_ on drop";
  substr $grid, $to + 1, 1, $ball;
  /\+/ and $success = "\e[JSUCCESS          ", last;
  $delay and sleep $delay;
  }
show;

print $success, "\n";
printf "\n$turns turns took %.3f seconds  %d usec/turn\n", time - $start,
  (time - $start) / $turns * 1e6;

