#!/usr/bin/perl -l

use strict; # https://rosettacode.org/wiki/Calendar
use warnings;
use Time::Local;

my $year = shift // 1969;
my $width = shift // 80;
my $columns = int +($width + 2) / 22 or die "width too short at $width";
print map { center($_, $width), "\n" } '<reserved for snoopy>', $year;
my @months = qw( January February March April May June
  July August September October November December );
my @days = qw( 31 28 31 30 31 30 31 31 30 31 30 31 );
(gmtime 86400 + timegm 1,1,1,28,1,$year)[3] == 29 and $days[1]++;
my @blocks = map # block per month
  {
  my $m = center($months[$_], 20) . "\nSu Mo Tu We Th Fr Sa\n" .
    "00 00 00 00 00 00 00\n" x 6;
  $m =~ s/00/  / for 1 .. (gmtime timegm 1,1,1,1,$_,$year )[6]; # day of week
  $m =~ s/00/ center($_, 2) /e for 1 .. $days[$_];
  $m =~ s/00/  /g;
  [ split /\n/, $m ]
  } 0 .. 11;
while( my @row = splice @blocks, 0, $columns ) # print by rows of months
  {
  print center(join('  ', map shift @$_, @row), $width) for 1 .. @{$row[0]};
  }

sub center
  {
  my ($string, $w) = @_;
  sprintf "%${w}s", $string . ' ' x ($w - length($string) >> 1);
  }
