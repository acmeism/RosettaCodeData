use strict;
use warnings;
use feature 'say';

sub identity_matrix {
    my($n) = shift() - 1;
    map { [ (0) x $_, 1, (0) x ($n - $_) ] } 0..$n
}

for (<4 5 6>) {
  say "\n$_:";
  say join ' ', @$_ for identity_matrix $_;
}
