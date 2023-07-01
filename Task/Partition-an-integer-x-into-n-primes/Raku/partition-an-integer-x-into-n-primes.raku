use Math::Primesieve;
my $sieve = Math::Primesieve.new;

# short circuit for '1' partition
multi partition ( Int $number, 1 ) { $number.is-prime ?? $number !! () }

multi partition ( Int $number, Int $parts where * > 0 = 2 ) {
    my @these = $sieve.primes($number);
    for @these.combinations($parts) { .return if .sum == $number };
    ()
}

# TESTING
(18,2, 19,3, 20,4, 99807,1, 99809,1, 2017,24, 22699,1, 22699,2, 22699,3, 22699,4, 40355,3)\
  .race(:1batch).map: -> $number, $parts {
    say (sprintf "Partition %5d into %2d prime piece", $number, $parts),
    $parts == 1 ?? ':  ' !! 's: ', join '+', partition($number, $parts) || 'not possible'
}
