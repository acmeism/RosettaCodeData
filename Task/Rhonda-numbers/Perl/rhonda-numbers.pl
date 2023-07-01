use strict;
use warnings;
use feature 'say';
use ntheory qw<is_prime factor vecsum vecprod todigitstring todigits>;

sub rhonda {
    my($b, $cnt) = @_;
    my(@r,$n);
    while (++$n) {
        push @r, $n if ($b * vecsum factor($n)) == vecprod todigits($n,$b);
        return @r if $cnt == @r;
    }
}

for my $b (grep { ! is_prime $_ } 2..36) {
    my @Rb = map { todigitstring($_,$b) } my @R = rhonda($b, 15);
    say <<~EOT;
        First 15 Rhonda numbers to base $b:
        In base $b: @Rb
        In base 10: @R
        EOT
}
