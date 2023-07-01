multi is-Brazilian (Int $n where $n %% 2 && $n > 6) { True }

multi is-Brazilian (Int $n) {
    LOOP: loop (my int $base = 2; $base < $n - 1; ++$base) {
        my $digit;
        for $n.polymod( $base xx * ) {
            $digit //= $_;
            next LOOP if $digit != $_;
        }
        return True
    }
    False
}

my $upto = 20;

put "First $upto Brazilian numbers:\n", (^Inf).hyper.grep( &is-Brazilian )[^$upto];

put "\nFirst $upto odd Brazilian numbers:\n", (^Inf).hyper.map( * * 2 + 1 ).grep( &is-Brazilian )[^$upto];

put "\nFirst $upto prime Brazilian numbers:\n", (^Inf).hyper(:8degree).grep( { .is-prime && .&is-Brazilian } )[^$upto];
