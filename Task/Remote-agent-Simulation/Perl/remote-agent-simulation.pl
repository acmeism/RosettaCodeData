#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Remote_agent
use warnings;
use List::Util qw( shuffle );
use Term::ReadKey;

# server

my $port = shift;

my ($wide, $high) = ( 30 ) x 2;
my $world = '-' x ($wide + 2) . "\n" .
  ('-' . ' ' x $wide . "-\n") x $high .
  '-' x ($wide + 2) . "\n";
my $balls = $world;
for my $try (1 .. 1e3) # try again if no mismatch
  {
  s/\w/ /g for $world, $balls;
  $world =~ s/ / qw(R G Y B)[rand 4] /ge; # fill in color sectors
  my @balls = shuffle map lc, $world =~ /\w/g;
  @balls[ @balls >> 1 .. $#balls] = (0) x @balls;
  @balls = shuffle @balls;
  $balls =~ s/ / shift @balls || 0 /ge; # add balls
  findmismatch() and last;
  }

#sub show
# {
# my @two = split /\n/, $balls;
# warn "$_ ", shift @two, "\n" for $world =~ /.+/g;
# }
#show();

my $gap = $wide + 3;
my @cells;
push @cells, $-[0] while $world =~ /\w/g;
my $agent = $cells[rand @cells]; # pick random starting cell
my $dirs = 'NESW' x 2;
my ($holds, $dir) = ( 0, substr $dirs, rand 4, 1 ); # random direction
my ($color, $ball) = map {substr $_, $agent, 1 } $world, $balls;
my %gap = ( N => -$gap, E => 1, S => $gap, W => -1 );
my %commands = (
  '^' => \&forward,
  '>' => sub { $dirs =~ /$dir(.)/ and $dir = $1 }, # turn right
  '<' => sub { $dirs =~ /(.)$dir/ and $dir = $1 }, # turn left
  '@' => \&get,
  '!' => \&drop,
  "\e" => sub {die "\nEnded by ESC\n" },
  );

sub drop
  {
  print 'a' x !$holds, 'S' x !!$ball; # errors
  if( $holds && !$ball )
    {
    substr $balls, $agent, 1, $holds;
    ($ball, $holds) = ($holds, 0);
    findmismatch() or print '+';
    }
  }

sub get
  {
  $ball =~ /[rgby]/ or print 's';
  $holds and print 'A';
  if( $ball and not $holds )
    {
    $holds = $ball;
    substr $balls, $agent, 1, 0;
    }
  }

sub forward
  {
  my $new = $agent + $gap{$dir};
  if( substr($world, $new, 1) =~ /\w/ ) # not wall
    {
    $agent = $new;
    ($color, $ball) = map {substr $_, $agent, 1 } $world, $balls;
    print $color, $ball || ''; # 0 means no ball
    }
  else { print '|'; }
  }

sub findmismatch
  {
  my $mask = $balls =~ tr/rgby/\0/cr =~ tr/rgby/\xff/r;
  lc($world & $mask) ne ($balls & $mask);
  }

my $terminal = 0;

if( $port ) # then we are tcp server
  {
  use IO::Socket;
  my $listen = IO::Socket::INET->new( LocalPort => $port,
    Listen => 10, Reuse => 1 ) or die $@;
# warn "waiting for connect\n";
  my $socket = $listen->accept;
  close STDIN; # redir STDIN and STDOUT to socket
  open STDIN, '<&', $socket or die "$! on input dup";
  close STDOUT;
  open STDOUT, '>&', $socket or die "$! on output dup";
  }
elsif( -t ) # running on a tty
  {
  $terminal = 1;
# warn "running on terminal\n";
  }
else # suitable for xinetd
  {
# warn "running as subprocess\n";
  }

eval # here so die when on tty can reset tty back to normal
  {
  local $/ = \1; # all commands are one byte
  local $| = 1;  # autoflush
  $terminal and ReadMode 'cbreak';
  print 'A'; # handshake
  <> eq 'A' or die "handshake failed";
# warn "got handshake reply\n";
  while( <> ) # command read loop
    {
    ( $commands{$_} // sub {die "invalid command <$_>"} )->();
    print '.'; # eol
    }
  1 } or warn $@;
$terminal and ReadMode 'restore';
#warn "final\n";
#show;
