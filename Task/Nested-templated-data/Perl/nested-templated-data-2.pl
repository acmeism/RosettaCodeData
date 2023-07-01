#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Nested_templated_data
use warnings;
use Data::Dump 'dd';

my $t = [
    [[1, 2],
     [3, 4, 1],
     5]];

my $p = [ map "Payload#$_", 0 .. 6 ];
dd { 'template' => $t, 'payload' => $p };

my $output = filltemplate( $t, $p );
dd { 'output' => $output };

sub filltemplate
  {
  my ($t, $p) = @_;
  return ref $t eq 'ARRAY' ? [ map filltemplate($_, $p), @$t ] : $p->[$t];
  }
