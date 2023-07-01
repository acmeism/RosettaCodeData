USING: io kernel math.primes.factors prettyprint sequences ;

: semiprime? ( n -- ? ) factors length 2 = ;
