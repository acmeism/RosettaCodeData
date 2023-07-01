unit sub MAIN (:$prisoners = 100, :$simulations = 10000);
my @prisoners = ^$prisoners;
my $half = floor +@prisoners / 2;

sub random ($n) {
    ^$n .race.map( {
        my @drawers = @prisoners.pick: *;
        @prisoners.map( -> $prisoner {
            my $found = 0;
            for @drawers.pick($half) -> $card {
                $found = 1 and last if $card == $prisoner
            }
            last unless $found;
            $found
        }
        ).sum == @prisoners
    }
    ).grep( *.so ).elems / $n * 100
}

sub optimal ($n) {
    ^$n .race.map( {
        my @drawers = @prisoners.pick: *;
        @prisoners.map( -> $prisoner {
            my $found = 0;
            my $card = @drawers[$prisoner];
            if $card == $prisoner {
                $found = 1
            } else {
                for ^($half - 1) {
                    $card = @drawers[$card];
                    $found = 1 and last if $card == $prisoner
                }
            }
            last unless $found;
            $found
        }
        ).sum == @prisoners
    }
    ).grep( *.so ).elems / $n * 100
}

say "Testing $simulations simulations with $prisoners prisoners.";
printf " Random play wins: %.3f%% of simulations\n", random $simulations;
printf "Optimal play wins: %.3f%% of simulations\n", optimal $simulations;
