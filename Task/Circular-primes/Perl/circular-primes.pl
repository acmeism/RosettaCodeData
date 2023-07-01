use strict;
use warnings;
use feature 'say';
use List::Util 'min';
use ntheory 'is_prime';

sub rotate { my($i,@a) = @_; join '', @a[$i .. @a-1, 0 .. $i-1] }

sub isCircular {
    my ($n) = @_;
    return 0 unless is_prime($n);
    my @circular = split //, $n;
    return 0 if min(@circular) < $circular[0];
    for (1 .. scalar @circular) {
        my $r = join '', rotate($_,@circular);
        return 0 unless is_prime($r) and $r >= $n;
    }
    1
}

say "The first 19 circular primes are:";
for ( my $i = 1, my $count = 0; $count < 19; $i++ ) {
    ++$count and print "$i " if isCircular($i);
}

say "\n\nThe next 4 circular primes, in repunit format, are:";
for ( my $i = 7, my $count = 0; $count < 4; $i++ ) {
    ++$count and say "R($i)" if is_prime 1 x $i
}

say "\nRepunit testing:";

for (5003, 9887, 15073, 25031, 35317, 49081) {
    say "R($_): Prime? " . (is_prime 1 x $_ ? 'True' : 'False');
}
