#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Terminal_control/Restricted_width_positional_input/No_wrapping
use warnings;
use List::Util qw( min max );
$| = 1;

sub label { printf "\e[%d;%dH%s", @_; }

sub getinput
  {
  my ($row, $column, $length, $prompt) = @_;
  defined $prompt and length $prompt < $column - 1 and
    label( $row, $column - length $prompt, $prompt);
  my $at = "\e[%d;%dH%-$length.${length}s\e[%d;%dH";
  my $input = '';
  my $pos = 0;
  use Term::ReadKey;
  eval
    {
    ReadMode 'cbreak';
    local $_;
    my $more = 1;
    while( $more )
      {
      printf $at, $row, $column, $input, $row, $column + $pos;
      0 < sysread *STDIN, $_, 1024 or last;
      print "\e[10;1H\e[J"; use Data::Dump 'dd'; dd $_;
      for( /\e[O\[][0-9;]*[A-~]|./gs )
        {
        /^[\n\r\e]\z/ ? do { $more = 0 } :
        /^[ -~]\z/ ? do {
          substr $input, $pos++, 0, $_; $input &= "\xff" x $length;
          $pos = min $pos, $length } :
        $_ eq "\b" ? do { $pos = max $pos - 1, 0; substr $input, $pos, 1, '' } :
        $_ eq "\e[D" ? do { $pos = max 0, $pos - 1 } :
        $_ eq "\e[C" ? do { $pos = min length $input, $pos + 1 } :
        $_ eq "\e[H" ? do { $pos = 0 } :
        $_ eq "\e[F" ? do { $pos = length $input } :
        $_ eq "\e[3~" ? do { length $input and substr $input, $pos, 1, ''; } :
        0;
        }
      }
    };
  ReadMode 'restore';
  return $input;
  }

print "\e[H\e[J";
#label(2, 5, "Enter input below");
my $text = getinput( 3, 25, 8, "test string: " );
print "\n\nyour input <$text>\n";
