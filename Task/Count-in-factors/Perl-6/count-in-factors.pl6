# Define a lazy list of primes.
# Uses the ... sequence operator with a lambda that calculates
# the next available prime by using some of the existing list
# as test divisors, so we rarely divide by anything that isn't
# known to be a prime already.  This is quite fast.
my @primes := 2, 3, 5, -> $p { ($p+2, $p+4 ... &prime)[*-1] } ... *;
my @isprime = False,False;   # 0 and 1 are not prime by definition
sub prime($i) { @isprime[$i] //= $i %% none @primes ...^ * > sqrt $i }

# Finds the factors of the given argument.
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

# An infinite loop, from 1 incrementing upward.
# calls factor() with each of 1, 2, 3, etc., receives an
# array containing that number's factors, and then
# formats and displays them.
say "$_: ", factors($_).join(" × ") for 1..*;
