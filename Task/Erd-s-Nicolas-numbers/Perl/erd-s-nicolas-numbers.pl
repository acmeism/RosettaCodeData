use v5.36;
use enum    qw(False True);
use ntheory qw(divisors divisor_sum);

sub is_Erdos_Nicolas ($n) {

    divisor_sum($n) > 2*$n or return False;

    my $sum   = 0;
    my $count = 0;

    foreach my $d (divisors($n)) {
        ++$count;        $sum += $d;
        return $count if ($sum == $n);
        return False  if ($sum > $n);
    }
}

my ($n, $count) = (2, 0);
until ($count == 8) {
    next unless 0 == ++$n % 2;
    if (my $key = is_Erdos_Nicolas $n) {
        printf "%8d == sum of its first %3d divisors\n", $n, $key;
        $count++;
    }
}
