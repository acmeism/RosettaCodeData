#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Terminal_control/Restricted_width_positional_input/With_wrapping
use warnings;
use Term::ReadKey;

sub input
  {
  my ($row, $column, $length) = @_;
  my ($input, $done, $start) = ( '', 0,
    "\e[$row;${column}H" . ' ' x $length . "\e[$row;${column}H");
  local $| = 1;
  ReadMode 'raw';
  until( $done )
    {
    print $start, substr $input, -$length;
    local $_ = ReadKey 0;
    if( tr/ -~// ) { $input .= $_ } # add char
    elsif( tr/\cu// ) { $input = '' } # clear all
    elsif( tr/\b\x7f// ) { chop $input } # delete last char
    elsif( tr/\n\r\e\cc// ) { $done++ } # guess!
    }
  ReadMode 'restore';
  return $input;
  }

print "\e[H\e[Jinput at row 3 column 5 length 8\n";
my $in = input( 3, 5, 8 );
print "\n\n\ninput is $in\n\n";
