use 5.036;
use bigint try => 'GMP';
use ntheory qw(:all);

sub difference_of_two_squares_solutions ($n) {

    my @solutions;
    my $limit = sqrtint($n);

    foreach my $divisor (divisors($n)) {

        last if $divisor > $limit;

        my $p = $divisor;
        my $q = $n / $divisor;

        ($p + $q) % 2 == 0 or next;

        my $x = ($q + $p) >> 1;
        my $y = ($q - $p) >> 1;

        unshift @solutions, [$x, $y];
    }

    return @solutions;
}

my $N    = 20;         # how many terms to compute
my %seen = (1 => 1);

my $index = 1;
say($index, ': ', 1);

OUTER: for (my $n = 1 ; ; ++$n) {

    my $r = (10**$n - 1) / 9;

    foreach my $xy (difference_of_two_squares_solutions($r)) {

        my $xsqr = $xy->[0]**2;
        my @d    = todigits($xsqr);

        next if $d[0] == 1;
        next if !vecall { $_ } @d;
        next if !is_square(fromdigits([map { $_ - 1 } @d]));

        if (!$seen{$xsqr}++) {
            say(++$index, ': ', $xsqr);
            last OUTER if ($index >= $N);
        }
    }
}
