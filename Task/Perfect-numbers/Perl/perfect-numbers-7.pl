use ntheory qw(is_mersenne_prime valuation hammingweight is_power sqrtint);

sub is_even_perfect {
    my ($n) = @_;

    $n % 2 == 0 || return;

    my $square = 8 * $n + 1;
    is_power($square, 2) || return;

    my $k = (sqrtint($square) + 1) / 2;
    hammingweight($k) == 1 && is_mersenne_prime(valuation($k, 2));
}
