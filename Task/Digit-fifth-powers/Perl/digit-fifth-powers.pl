use strict;
use warnings;
use feature 'say';
use List::Util 'sum';

for my $power (3..6) {
    my @matches;
    for my $n (2 .. 9**$power * $power) {
        push @matches, $n if $n == sum map { $_**$power } split '', $n;
    }
    say "\nSum of powers of n**$power: " . join(' + ', @matches) . ' = ' . sum @matches;
}
