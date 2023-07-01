use Math::Primesieve;

sub prime-hash (Int $max) {
    my $sieve = Math::Primesieve.new;
    my @primes = $sieve.primes($max);
    @primes.Set;
}

sub MAIN ($start, $stop = Nil, $display = <slice>) {
    my $end = $stop // $start;
    my %primes = prime-hash(100*$end);
    my @emirps = lazy gather for 1 .. * -> $n {
        take $n if %primes{$n} and %primes{$n.flip} and $n != $n.flip
    }

    given $display {
        when 'slice'  { return @emirps[$start-1 .. $end-1] };
        when 'values' {
            my @values = gather for @emirps {
                .take if $start < $_ < $end;
                last if $_> $end
            }
            return @values
        }
    }
}
