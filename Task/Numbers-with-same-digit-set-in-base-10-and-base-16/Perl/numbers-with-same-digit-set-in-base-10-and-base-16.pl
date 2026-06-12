use strict;
no warnings;
use feature 'say';

sub eqv { (join '', sort split '', $_[0]) eq (join '', sort split '', $_[1]) }
say join ' ', grep { eqv $_, sprintf '%x', $_ } 1..100_000;
