use strict;
use warnings;
use feature 'say';
use ntheory qw/divisor_sum divisors/;

sub odd_abundants {
    my($start,$count) = @_;
    my $n = int(( $start + 2 ) / 3);
    $n   += 1 if 0 == $n % 2;
    $n   *= 3;
    my @out;
    while (@out < $count) {
        $n += 6;
        next unless (my $ds = divisor_sum($n)) > 2*$n;
        my @d = divisors($n);
        push @out, sprintf "%6d: divisor sum: %s = %d", $n, join(' + ', @d[0..@d-2]), $ds-$n;
    }
    @out;
}

say 'First 25 abundant odd numbers:';
say for odd_abundants(1, 25);
say "\nOne thousandth abundant odd number:\n", (odd_abundants(1, 1000))[999];
say "\nFirst abundant odd number above one billion:\n", odd_abundants(999_999_999, 1);
