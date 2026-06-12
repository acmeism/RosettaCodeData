use strict;
use warnings;
use ntheory <forperm is_prime vecmax>;

my @p;
for my $c (0..7) {
    forperm {
        my $n = join '', @_;
        push @p, $n if $n !~ /^0/ and is_prime($n);
    } @{[0..$c]};
}
print vecmax(@p) . "\n";
