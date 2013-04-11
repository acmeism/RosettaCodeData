constant @primes = 2, 3, 5, -> $n is copy {
    repeat { $n += 2 } until $n %% none @primes ... { $_ * $_ >= $n }
    $n;
} ... *;

sub factors(Int $remainder is copy) {
  return 1 if $remainder <= 1;
  gather for @primes -> $factor {
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

say factors 536870911;
