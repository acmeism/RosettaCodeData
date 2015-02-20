sub tri
{
    my $n = shift;
    return $n*($n+1) / 2;
}

sub sum
{
    my $n = (shift) - 1;
    return (3 * tri($n / 3) + 5 * tri($n / 5) - 15 * tri($n / 15));
}

say sum(1e3);
use bigint; # Machine precision was sufficient for the first calculation
say sum(1e20);
