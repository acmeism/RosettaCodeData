# short circuit for '1' partition
multi partition ( Int $number, 1 ) { $number.is-prime ?? $number !! () }

my @primes = lazy (^Inf).grep: &is-prime;

multi partition ( Int $number, Int $parts where * > 1 = 2 ) {
    my @these = @primes[^($number div $parts)];
    shift @these if (($number %% 2) && ($parts %% 2)) || (($number % 2) && ($parts % 2));
    for @these.combinations($parts - 1) {
        my $maybe = $number - .sum;
        return (|$_, $maybe) if $maybe.is-prime && ($maybe ∉ $_)
    };
    ()
}

# TESTING
(18,2, 19,3, 20,4, 99807,1, 99809,1, 99820,6, 2017,24, 22699,1, 22699,2, 22699,3, 22699,4, 40355,3)\
  .race(:1batch).map: -> $number, $parts {
    say (sprintf "Partition %5d into %2d prime piece", $number, $parts),
    $parts == 1 ?? ':  ' !! 's: ', join '+', partition($number, $parts) || 'not possible'
}
