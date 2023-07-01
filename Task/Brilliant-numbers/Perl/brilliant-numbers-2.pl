use 5.020;
use strict;
use warnings;

use ntheory qw(:all);
use experimental qw(signatures);

sub is_briliant_number ($n) {
    is_semiprime($n) || return;
    my @f = factor($n);
    length($f[0]) == length($f[1]);
}

sub next_brilliant_number ($n) {
    ++$n while not is_briliant_number($n);
    $n;
}

sub brilliant_numbers_count ($n) {

    use integer;

    my $count = 0;
    my $len   = length(sqrtint($n));

    foreach my $k (1 .. $len - 1) {
        my $pi = prime_count(10**($k - 1), 10**$k - 1);
        $count += binomial($pi, 2) + $pi;
    }

    my $min = 10**($len - 1);
    my $max = 10**$len - 1;

    my $pi_min = prime_count($min);
    my $pi_max = prime_count($max);

    my $j  = -1;

    forprimes {
        if ($_*$_ <= $n) {
            $count += (($max <= $n/$_) ? $pi_max : prime_count($n/$_)) - $pi_min - ++$j;
        }
        else {
            lastfor;
        }
    } $min, $max;

    return $count;
}

say "First 100 brilliant numbers:";

my @nums;

for (my $k = 1 ; scalar(@nums) < 100 ; ++$k) {
    push(@nums, $k) if is_briliant_number($k);
}

while (@nums) {
    my @slice = splice(@nums, 0, 10);
    say join ' ', map { sprintf("%4s", $_) } @slice;
}

say '';

foreach my $n (1 .. 13) {
    my $v = next_brilliant_number(vecprod((10) x $n));
    printf("First brilliant number >= 10^%d is %s", $n, $v);
    printf(" at position %s\n", brilliant_numbers_count($v));
}
