sub primes ( UInt $n ) {
    gather {
        # create an iterator from 2 to $n (inclusive)
        my $iterator := (2..$n).iterator;

        loop {
            # If it passed all of the filters it must be prime
            my $prime := $iterator.pull-one;
            # unless it is actually the end of the sequence
            last if $prime =:= IterationEnd;

            take $prime; # add the prime to the `gather` sequence

            # filter out the factors of the current prime
            $iterator := Seq.new($iterator).grep(* % $prime).iterator;
            # (2..*).grep(* % 2).grep(* % 3).grep(* % 5).grep(* % 7)…
        }
    }
}

put primes( 100 );
