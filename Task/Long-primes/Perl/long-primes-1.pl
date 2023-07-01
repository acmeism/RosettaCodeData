use ntheory qw/divisors powmod is_prime/;

sub is_long_prime {
    my($p) = @_;
    return 0 unless is_prime($p);
    for my $d (divisors($p-1)) {
        return $d+1 == $p if powmod(10, $d, $p) == 1;
    }
    0;
}

print "Long primes ≤ 500:\n";
print join(' ', grep {is_long_prime($_) } 1 .. 500), "\n\n";

for my $n (500, 1000, 2000, 4000, 8000, 16000, 32000, 64000) {
    printf "Number of long primes ≤ $n: %d\n",  scalar grep { is_long_prime($_) } 1 .. $n;
}
