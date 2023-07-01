#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Galton_box_animation
use warnings;
$| = 1;

my $width = shift // 7;
my $bottom = 15;
my $blank = ' ' x ( 2 * $width + 1 ) . "\n";
my $line = ' ' x $width . '*' . ' ' x $width . "\n";
local $_ = join '', $blank x 5 . $line,
  map({ $line =~ s/ \* (.*) /* * $1/; ($blank, $line) } 2 .. $width ),
  $blank x $bottom;

my $gap = / \n/ && $-[0];
my $gl = qr/.{$gap}/s;
my $g = qr/.$gl/s;
my $center = $gap >> 1;
my %path = ('O* ' => 'O*X', ' *O' => 'X*O');

print "\e[H\e[J$_";
while( not /(?:O$g){$bottom}/ )
  {
  my $changes = s!O($gl)( \* |O\* | \*O)! " $1" .
    ($path{$2} // (rand(2) < 1 ? "X* " : " *X")) !ge +
    s/O($g) / $1X/g +
    s/^ {$center}\K ($g $g) /O$1 /;
  tr/X/O/;
  print "\e[H$_";
  $changes or last;
  select undef, undef, undef, 0.05;
  }
