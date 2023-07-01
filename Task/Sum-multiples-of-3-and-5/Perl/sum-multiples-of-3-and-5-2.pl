use v5.20;
use experimental qw(signatures);

sub tri($n) {
   $n*($n+1) / 2;
}

sub sum_multiples($n, $limit) {
   $n * tri( int( ($limit - 1) / $n ) )
}

sub sum($n) {
   sum_multiples(3, $n) + sum_multiples(5, $n) - sum_multiples(15, $n);
}

say sum 1e3;
use bigint; # Machine precision was sufficient for the first calculation
say sum 1e20;
