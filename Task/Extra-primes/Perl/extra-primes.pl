use strict;
use warnings;
use feature 'say';
use ntheory qw(is_prime vecsum todigits forprimes);

my $str;
forprimes {
    is_prime(vecsum(todigits($_))) and /^[2357]+$/ and $str .= sprintf '%-5d', $_;
} 1e4;
say $str =~ s/.{1,80}\K /\n/gr;
