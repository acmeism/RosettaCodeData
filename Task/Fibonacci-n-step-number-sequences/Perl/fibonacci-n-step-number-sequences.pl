use strict;
use warnings;
use feature <say signatures>;
no warnings 'experimental';
use List::Util <max sum>;

sub fib_n ($n = 2, $xs = [1], $max = 100) {
    my @xs = @$xs;
    while ( $max > (my $len = @xs) ) {
        push @xs, sum @xs[ max($len - $n, 0) .. $len-1 ];
    }
    @xs
}

say $_-1 . ': ' . join ' ', (fib_n $_)[0..19] for 2..10;
say "\nLucas: " . join ' ',  fib_n(2, [2,1], 20);
