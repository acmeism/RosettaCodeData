#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Robots
use warnings;
use List::Util qw( shuffle );
use Term::ReadKey;
use IO::Select;

my ($rows, $columns) = split ' ', qx(stty size);
$rows -= 6;
my $maze = '*' x $columns . ('*' .
  ' ' x ( $columns - 2 ) . '*') x ($rows - 2) . '*' x $columns;
my $gap = qr/.{@{[ $columns - 1 ]}}/;

my @where;
push @where, $-[0] while $maze =~ / /g;
@where = shuffle @where;
substr $maze, shift @where, 1, $_ for
  '@', ('+') x 10, ('*') x ($rows * $columns / 38);
my $hints = "\@ = you  + = robot  * = danger
h,j,k,l or arrows to move   't' to teleport";

sub jump
  {
  my @where;
  pos($maze) = 0;
  push @where, $-[0] while $maze =~ / /g;
  return $where[rand @where];
  }

ReadMode 'cbreak';
my $sel = IO::Select->new(*STDIN);
my $result = eval
  {
  while( 1 )
    {
    -M $0 < 0 and exec $0; # restart if source changed :)
    print "\e[H$maze$hints\n\e[J"
      =~ s/\+/\e[91;103m+\e[m/gr =~ s/\@/\e[97;42m\@\e[m/gr;
    for ( $sel->can_read( 0.5 ) )
      {
      sysread *STDIN, $_, 1024;
      for ( /\e(?:\[M...|[O\[][0-9;]*[A-~])|./gs ) # keep esc seq together
        {
        /^(?:q|\e)\z/i ? die "quit\n" :
          /^(?:h|\e\[D)\z/ ? ( $maze =~ s/ \@/\@ / or die "dead\n" ) :
          /^(?:l|\e\[C)\z/ ? ( $maze =~ s/\@ / \@/ or die "dead\n" ) :
          /^(?:k|\e\[A)\z/ ? ( $maze =~ s/ ($gap)\@/\@$1 / or die "dead\n" ) :
          /^(?:j|\e\[B)\z/ ? ( $maze =~ s/\@($gap) / $1\@/ or die "dead\n" ) :
          /^t\z/i ? do { $maze =~ s/\@/ /; substr $maze, jump(), 1, '@' } :
          0;
        }
      # move robots
      my $player = index $maze, '@';
      my ($x, $y) = ($player % $columns, int $player / $columns);
      my @bots;
      pos($maze) = 0;
      push @bots, $-[0] while $maze =~ /\+/g;
      for my $bot ( @bots )
        {
        my ($rx, $ry) = ($bot % $columns, int $bot / $columns);
        substr $maze, $rx + $ry * $columns, 1, ' ';
        my ($newx, $newy) = ($rx + ($x <=> $rx), $ry + ($y <=> $ry));
        '@' eq substr $maze, $newx + $newy * $columns, 1 and die "dead\n";
        (substr $maze, $newx + $newy * $columns, 1) =~ s/ /+/;
        }
      $maze =~ /\+/g or die "win\n";
      }
    }
  } || $@;
ReadMode 'restore';
print $@;
