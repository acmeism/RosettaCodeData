use ntheory qw(is_mersenne_prime valuation);

sub is_even_perfect {
    my ($n) = @_;
    my $v = valuation($n, 2) || return;
    my $m = ($n >> $v);
    ($m & ($m + 1)) && return;
    ($m >> $v) == 1 || return;
    is_mersenne_prime($v + 1);
}
