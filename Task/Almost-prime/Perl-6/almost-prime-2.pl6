constant @primes = 2, |(3, 5, 7 ... *).grep: *.is-prime;

multi sub factors(1) { 1 }
multi sub factors(Int $remainder is copy) {
    gather for @primes -> $factor {
        # if remainder < factor², we're done
        if $factor * $factor > $remainder {
            take $remainder if $remainder > 1;
            last;
        }
        # How many times can we divide by this prime?
        while $remainder %% $factor {
            take $factor;
            last if ($remainder div= $factor) === 1;
        }
    }
}

constant @factory = lazy 0..* Z=> flat (0, 0, map { +factors($_) }, 2..*);

sub almost($n) { map *.key, grep *.value == $n, @factory }

put almost($_)[^10] for 1..5;
