use strict;
use warnings;
use feature 'say';

sub comma { reverse ((reverse shift) =~ s/(.{3})/$1,/gr) =~ s/^,//r }

sub is_gapful { my $n = shift; 0 == $n % join('', (split //, $n)[0,-1]) }

use constant Inf => 1e10;
for ([1e2, 30], [1e6, 15], [1e9, 10], [7123, 25]) {
    my($start, $count) = @$_;
    printf "\nFirst $count gapful numbers starting at %s:\n", comma $start;
    my $n = 0; my $g = '';
    $g .= do { $n < $count ? (is_gapful($_) and ++$n and "$_ ") : last } for $start .. Inf;
    say $g;
}
