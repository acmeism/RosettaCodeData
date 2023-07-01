#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/ABC_Problem
use warnings;

printf "%30s  %s\n", $_, can_make_word( $_,
  'BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM' )
  for qw( A BARK BOOK TREAT COMMON SQUAD CONFUSE );

sub can_make_word
  {
  my ($word, $blocks) = @_;
  my $letter = chop $word or return 'True';
  can_make_word( $word, $` . $' ) eq 'True' and return 'True'
    while $blocks =~ /\w?$letter\w?/gi;
  return 'False';
  }
