constant @primes = 2, |(3, 5, 7 ... *).grep: *.is-prime;

multi factors(1) { 1 }
multi factors(Int $remainder is copy) {
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

say "$_: ", factors($_).join(" × ") for 1..*;
