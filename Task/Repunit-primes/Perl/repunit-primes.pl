use strict;
use warnings;
use ntheory <is_prime fromdigits>;

my $limit = 1000;

print "Repunit prime digits (up to $limit) in:\n";

for my $base (2..16) {
    printf "Base %2d: %s\n", $base, join ' ', grep { is_prime $_ and is_prime fromdigits(('1'x$_), $base) and " $_" } 1..$limit
}
