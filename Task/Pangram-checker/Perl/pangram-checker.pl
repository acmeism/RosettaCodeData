use strict;
use warnings;
use feature 'say';

sub pangram1 {
    my($str,@set) = @_;
    use List::MoreUtils 'all';
    all { $str =~ /$_/i } @set;
}

sub pangram2 {
    my($str,@set) = @_;
    '' eq (join '',@set) =~ s/[$str]//gir;
}

my @alpha = 'a' .. 'z';

for (
    'Cozy Lummox Gives Smart Squid Who Asks For Job Pen.',
    'Crabby Lummox Gives Smart Squid Who Asks For Job Pen.'
) {
    say pangram1($_,@alpha) ? 'Yes' : 'No';
    say pangram2($_,@alpha) ? 'Yes' : 'No';
}
