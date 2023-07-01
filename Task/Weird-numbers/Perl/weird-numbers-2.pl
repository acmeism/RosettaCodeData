use 5.010;
use strict;
use ntheory qw(vecsum divisors divisor_sum);

sub is_pseudoperfect {
    my ($n, $d, $s, $m) = @_;

    $d //= do { my @d = divisors($n); pop(@d); \@d };
    $s //= vecsum(@$d);
    $m //= $#$d;

    return 0 if $m < 0;

    while ($d->[$m] > $n) {
        $s -= $d->[$m--];
    }

    return 1 if ($n == $s or $d->[$m] == $n);

    is_pseudoperfect($n-$d->[$m], $d, $s-$d->[$m], $m - 1) ||
    is_pseudoperfect($n,          $d, $s-$d->[$m], $m - 1);
}

sub is_weird {
    my ($n) = @_;
    divisor_sum($n) > 2*$n and not is_pseudoperfect($n);
}

my @weird;
for (my $k = 1 ; @weird < 25 ; ++$k) {
    push(@weird, $k) if is_weird($k);
}

say "The first 25 weird numbers:\n@weird";
