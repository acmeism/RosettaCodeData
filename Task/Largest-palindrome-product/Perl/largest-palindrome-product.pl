use strict;
use warnings;
use feature 'say';
use ntheory 'divisors';

for my $l (2..7) {
    LOOP:
    for my $p (reverse map { $_ . reverse $_ } 10**($l-1) .. 10**$l - 1)  {
        my @f = reverse grep { length == $l } divisors $p;
        next unless @f >= 2 and $p == $f[0] * $f[1];
        say "Largest palindromic product of two @{[$l]}-digit integers: $f[1] × $f[0] = $p" and last LOOP;
    }
}
