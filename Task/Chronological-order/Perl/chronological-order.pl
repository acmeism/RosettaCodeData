#!/usr/bin/perl

use strict; # https://rosettacode.org/wiki/Chronological_order
use warnings;
use List::AllUtils qw( nsort_by );
$SIG{__WARN__} = sub { die @_ };

sub chronosort { join '',
  nsort_by { my ($n, $type) = (split)[-2,-1]; $type eq 'CE' ? $n : -$n }
  split /^/, shift }

print "\n", chronosort(<<END);
Pi                250  BCE
Magic Squares     2200 BCE
Kwarizmi          830  CE
Dice              3000 BCE
Liber Abaci       1202 CE
Euclid's Elements 300  BCE
Euler's Number    1727 CE
The Abacus        1200 CE
END

print "\n", chronosort(<<END);
Pi             250  BCE
Magic Squares  2200 BCE
Kwarizmi       830  CE
Dice           3000 BCE
Liber Abaci    1202 CE
Euler's Number 1727 CE
The Abacus     1200 CE
END

print "\n", chronosort(<<END);
Pi                250  BCE
FTSE 100          1984 CE
Magic Squares     2200 BCE
Kwarizmi          830  CE
Dice              3000 BCE
Liber Abaci       1202 CE
Euclid's Elements 300  BCE
Euler's Number    1727 CE
The Abacus        1200 CE
END
