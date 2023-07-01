my $nth = 1_000_000;

my $k = Int.new: 2.4 * $nth * log($nth) / 2;

my int @sieve;

@sieve[$k] = 0;

hyper for 1 .. $k -> \i {
    my int $j = i;
    while (my int $l = i + $j + 2 * i * $j) < $k {
        @sieve[$l] = 1;
        $j = $j + 1;
    }
}

@sieve[0] = 1;

say "First 100 Sundaram primes:";
say @sieve.kv.map( { next if $^v; $^k * 2 + 1 } )[^100]».fmt("%4d").batch(10).join: "\n";

say "\nOne millionth:";
my ($count, $index);
for @sieve {
    $count += !$_;
    say $index * 2 + 1 and last if $count == $nth;
    ++$index;
}
