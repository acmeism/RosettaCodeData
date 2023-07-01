use Math::Primesieve;

constant $max    = 1_000_000;
constant @primes = Math::Primesieve.primes($max);
constant @diffs  = @primes.skip Z- @primes;

say "Given all ordered primes <= $max, sets with successive differences of:";
for (2,), (1,), (2,2), (2,4), (4,2), (6,4,2) -> @succ {
    my $size = @succ.elems;

    my @group_start_offsets = @diffs.rotor( $size => 1-$size )
                                    .grep(:k, { $_ eqv @succ });

    my ($first, $last) = @group_start_offsets[0, *-1]
                         .map: { @primes.skip($_).head($size + 1) };

    say sprintf '%10s has %5d sets: %15s … %s',
        @succ.gist, @group_start_offsets.elems, $first, $last;
}
