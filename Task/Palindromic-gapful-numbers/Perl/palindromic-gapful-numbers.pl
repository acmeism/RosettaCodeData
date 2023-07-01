use strict;
use warnings;
use feature 'say';

use constant Inf  => 1e10;

sub is_p_gapful {
    my($d,$n) = @_;
    return '' unless 0 == $n % 11;
    my @digits = split //, $n;
    $d eq $digits[0] and (0 == $n % ($digits[0].$digits[-1])) and $n eq join '', reverse @digits;
}

for ([1, 20], [86, 15]) {
    my($offset, $count) = @$_;
    say "Palindromic gapful numbers starting at $offset:";
    for my $d ('1'..'9') {
        my $n = 0; my $out = "$d: ";
        $out .= do { $n+1 < $count+$offset ? (is_p_gapful($d,$_) and ++$n and $n >= $offset and "$_ ") : last } for 100 .. Inf;
        say $out
    }
    say ''
}
