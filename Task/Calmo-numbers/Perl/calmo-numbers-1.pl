use v5.36;
use ntheory<is_prime divisors>;
use List::Util 'all';
use experimental 'for_list';

sub c_divisors ($n) { my @d = divisors $n; pop @d; shift @d; @d }

for (2..1000) {
    my @d = c_divisors $_;
    next unless @d and 0 == @d%3;
    my @sums;
    for my($a,$b,$c) (@d) { push @sums, $a+$b+$c }
    print "$_ " if all { is_prime $_ } @sums;
}
say '';
