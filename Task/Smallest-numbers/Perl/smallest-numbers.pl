use strict;
use warnings;
use feature 'say';
use List::Util 'first';
use Math::AnyNum 'ipow';

sub smallest { first { ipow($_,$_) =~ /$_[0]/ } 1..1e4 }
say join ' ', map { smallest($_) } 0..50;
