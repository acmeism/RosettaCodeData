my @primes = (3..60).grep: &is-prime;

print 'First four Giuga numbers: ';

put sort flat (2..4).map: -> $c {
    @primes.combinations($c).map: {
        my $n = [×] 2,|$_;
        $n if all .map: { ($n / $_ - 1) %% $_ };
    }
}
