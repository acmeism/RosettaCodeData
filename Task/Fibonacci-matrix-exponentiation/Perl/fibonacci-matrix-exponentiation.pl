use strict;
use warnings;

use Math::AnyNum qw(:overload fibmod floor);
use Math::MatrixLUP;

sub fibonacci {
    my $M = Math::MatrixLUP->new([ [1, 1], [1,0] ]);
    (@{$M->pow(shift)})[0][1]
}

for my $n (16, 32) {
    my $f = fibonacci(2**$n);
    printf "F(2^$n) = %s ... %s\n",  substr($f,0,20), $f % 10**20;
}

sub binet_approx {
    my($n) = @_;
    use constant PHI =>   sqrt(1.25) + 0.5 ;
    use constant IHP => -(sqrt(1.25) - 0.5);
    (log(PHI)*$n - log(PHI-IHP))
}

sub nth_fib_first_k_digits {
    my($n,$k) = @_;
    my $f = binet_approx($n);
    floor(exp($f - log(10)*(floor($f / log(10) + 1))) * 10**$k)
}

sub nth_fib_last_k_digits {
    my($n,$k) = @_;
    fibmod($n, 10**$k);
}

print "\n";
for my $n (16, 32, 64) {
    my $first20 = nth_fib_first_k_digits(2**$n, 20);
    my $last20  = nth_fib_last_k_digits(2**$n, 20);
    printf "F(2^$n) = %s ... %s\n", $first20, $last20;
}
