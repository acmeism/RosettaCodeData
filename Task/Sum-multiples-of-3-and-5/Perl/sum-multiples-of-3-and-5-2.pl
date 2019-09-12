use feature 'say';
sub tri
{
    my $n = shift;
    return $n*($n+1) / 2;
}

sub sum
{
    my $n = (shift) - 1;
    (3 * tri( int($n/3) ) + 5 * tri( int($n/5) ) - 15 * tri( int($n/15) ) );
}

say sum(1e3);
use bigint; # Machine precision was sufficient for the first calculation
say sum(1e20);
