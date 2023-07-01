use feature 'say';
use ntheory 'is_prime';

sub cuban_primes {
    my ($n) = @_;

    my @primes;
    for (my $k = 1 ; ; ++$k) {
        my $p = 3 * $k * ($k + 1) + 1;
        if (is_prime($p)) {
            push @primes, $p;
            last if @primes >= $n;
        }
    }

    return @primes;
}

sub commify {
    scalar reverse join ',', unpack '(A3)*', reverse shift;
}

my @c = cuban_primes(200);

while (@c) {
    say join ' ', map { sprintf "%9s", commify $_ } splice(@c, 0, 10);
}

say '';
for my $n (1 .. 6) {
    say "10^$n-th cuban prime is: ", commify((cuban_primes(10**$n))[-1]);
}
