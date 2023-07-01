#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Camel_case_and_snake_case
use warnings;

my @words = (
  "snakeCase", "snake_case", "variable_10_case", "variable10Case", "#rgo rE tHis",
  "hurry-up-joe!", "c://my-docs/happy_Flag-Day/12.doc", "  spaces  "
   );

sub tosnake
  {
  shift =~ s/^ +| +$//gr =~ s/[A-Z]/_\l$&/gr =~ tr/ -/_/r =~ s/__+/_/gr;
  }

sub tocamel
  {
  shift =~ s/^ +| +$//gr =~ s/[ _-]([a-z0-9])/\u$1/gir;
  }

print "to snake case\n\n";
for my $word ( @words )
  {
  printf "%35s -> %s\n", $word, tosnake($word);
  }

print "\nto camel case\n\n";
for my $word ( @words )
  {
  printf "%35s -> %s\n", $word, tocamel($word);
  }
