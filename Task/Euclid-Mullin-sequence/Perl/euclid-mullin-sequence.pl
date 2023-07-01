use strict;
use warnings;
use feature 'say';
use ntheory <factor vecprod vecmin>;

my @Euclid_Mullin = 2;
push @Euclid_Mullin, vecmin factor (1 + vecprod @Euclid_Mullin) for 2..16+11;

say "First sixteen: @Euclid_Mullin[ 0..15]";
say "Next eleven:   @Euclid_Mullin[16..26]";
