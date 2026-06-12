#!/usr/bin/perl

use strict;
use warnings;

my @words;
@ARGV = 'unixdict.txt';
while( <> )
  {
  chomp;
  length > 11 or next;
  for my $prev ( @{ $words[length] } )
    {
    ($prev ^ $_) =~ tr/\0//c == 1 and printf "%30s <-> %s\n", $prev, $_;
    }
  push @{ $words[length] }, $_;
  }
