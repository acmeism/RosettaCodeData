#!/usr/bin/perl

use strict;
use warnings;
use Curses;
use Term::ReadKey;
use Time::HiRes qw( time );
use IO::Select;

my $delay = 1;
my $width = 12;
my $oneshort = $width - 1;
my $g3 = qr/(..{$oneshort})/s;
my $g4 = qr/(.{$oneshort})/s;
my $below = qr/....{$oneshort}/s;
my $height = 20;
my $well = ( '|' . ' ' x $width . "|\n" ) x $height . '-' x($width + 2) . "\n";
my $piece;
my $nexttime = time + $delay;
my $sel = IO::Select->new( *STDIN );

sub transpose
  {
  local $_ = $well;
  $well = '';
  $well .= "\n" while s/^./ $well .= $&; ''/gem;
  }

sub place
  {
  substr $well, $width / 2 - 1 + ($width + 3) * $_, 4, shift for 0 .. 3;
  }

my %shape =
  (
  I => [' O  ', ' O  ', ' O  ', ' O  '],
  J => ['    ', '    ', 'OOO ', '  O '],
  L => ['    ', '    ', ' OOO', ' O  '],
  O => ['    ', '    ', ' OO ', ' OO '],
  S => ['    ', '    ', ' OO ', 'OO  '],
  T => ['    ', '    ', ' O  ', 'OOO '],
  Z => ['    ', '    ', ' OO ', '  OO'],
  );

sub add
  {
  if( $well =~ /^(. *.\n){4}/ )
    {
    place $shape{$piece}->@*;
    $piece = (keys %shape)[rand keys %shape];
    }
  else
    {
    die "end of game\n";
    }
  }

sub rotate
  {
  s/   ${g3}OO $g3 OO/  O$1 OO$2 O / or # Z
  s/  O$g3 OO$g3 O /   $1OO $2 OO/ or

  s/   $g3 OO${g3}OO / O $1 OO$2  O/ or # S
  s/ O $g3 OO$g3  O/   $1 OO$2OO / or

  s/   ${g3}OOO${g3}O  /OO $1 O $2 O / or # L
  s/OO $g3 O $g3 O /   $1  O$2OOO/ or
  s/   $g3  O${g3}OOO/ O $1 O $2 OO/ or
  s/ O $g3 O $g3 OO/   $1OOO$2O  / or

  s/   ${g3}OOO$g3  O/ O $1 O $2OO / or # J
  s/ O $g3 O ${g3}OO /   $1O  $2OOO/ or
  s/   ${g3}O  ${g3}OOO/ OO$1 O $2 O / or
  s/ OO$g3 O $g3 O /   $1OOO$2  O/ or

  s/   $g3 O ${g3}OOO/ O $1 OO$2 O / or # T
  s/ O $g3 OO$g3 O /   $1OOO$2 O / or
  s/   ${g3}OOO$g3 O / O $1OO $2 O / or
  s/ O ${g3}OO $g3 O /   $1 O $2OOO/ or

  s/    $g4    $g4    ${g4}OOOO/ O  $1 O  $2 O  $3 O  / or # I
  s/ O  $g4 O  $g4 O  $g4 O  /    $1    $2    $3OOOO/ or
  s/O   ${g4}O   ${g4}O   ${g4}O   /    $1    $2    $3OOOO/ or
  s/   O$g4   O$g4   O$g4   O/    $1    $2    $3OOOO/

    for $well;
  }

sub step
  {
  if( $well =~ s/(?<=\|)#{$width}(?=\|)/ '=' x $width /e ) # full row?
    {
    transpose();
    $well =~ s/(.*)=/ $1/g; # remove full row
    transpose();
    }
  elsif( $well !~ /O/ ) # any O ?
    {
    add();
    }
  elsif( not down() ) # can't move down
    {
    $well =~ tr/O/#/; # convert to #
    }
  }

sub down
  {
  $well !~ /O/ || $well =~ /O$below[#-]/ and return 0;
  transpose();
  $well =~ s/(O+) / $1/g;
  transpose();
  return 1;
  }

sub drop { 1 while down() }

sub right { $well =~ /O[#|]/ or $well =~ s/(O+) / $1/g }

sub left { $well =~ /[#|]O/ or $well =~ s/ (O+)/$1 /g }

sub draw
  {
  addstr( 2, 0, ($well . "\n\n")  =~ s/^/' ' x 20 /gmer);
  my $row = 4;
  addstr( $row++, 10, $_ ) for @{ $shape{$piece} };
  addstr( 22, 0, ' ' );
  refresh;
  };

sub eventloop
  {
  while( 1 )
    {
    my $time = time;
    my $delta = $nexttime - $time;
    if( $delta <= 0 )
      {
      step();
      $nexttime = time + $delay;
      }
    else
      {
      draw();
      for ( $sel->can_read( $delta ) )
        {
        sysread *STDIN, $_, 1024;
        for ( /\e(?:\[M...|[O\[][0-9;]*[A-~])|./gs ) # keep esc seq together
          {
          /^(?:q|\e)\z/i ? die "quit\n" :
            /^(?:h|\e\[D)\z/ ? left() :
            /^(?:l|\e\[C)\z/ ? right() :
            /^(?:r|\e\[A)\z/ ? rotate() :
            /^(?:[j ]|\e\[B)\z/ ? drop() :
            0;
          }
        }
      }
    }
  }

$piece = (keys %shape)[rand keys %shape];
initscr();
clear;
ReadMode 'cbreak';
eval { eventloop() };
my $errormsg = $@;
ReadMode 'restore';
endwin();
print $errormsg;
