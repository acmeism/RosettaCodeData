my @primes = lazy gather for 1 .. * { .take if $_.is-prime }

say "The first twenty primes:\n   ", "[{@primes[^20].fmt("%d", ', ')}]";
say "The primes between 100 and 150:\n   ", "[{@primes.&between(100, 150).fmt("%d", ', ')}]";
say "The number of primes between 7,700 and 8,000:\n   ", +@primes.&between(7700, 8000);
say "The 10,000th prime:\n   ", @primes[9999];

sub between (@p, $l, $u) {
    gather for @p { .take if $l < $_ < $u; last if $_ >= $u }
}
