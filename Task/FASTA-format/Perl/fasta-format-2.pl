#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/FASTA_format
use warnings;

my $fasta_example = <<''; # end at first empty line
>Rosetta_Example_1
THERECANBENOSPACE
>Rosetta_Example_2
THERECANBESEVERAL
LINESBUTTHEYALLMUST
BECONCATENATED

open my $fh, '<', \$fasta_example or die "$! on open";
local $/ = "\n>"; # to read one sequence at a time
while( <$fh> )
  {
  chomp;
  print s/^>//r   # remove a leading '>' if present
    =~ s/\n/: /r  # change the first newline to ': '
    =~ tr/\n//dr, # remove the rest of the newlines
    "\n";         # and put one newline at the end
  }
