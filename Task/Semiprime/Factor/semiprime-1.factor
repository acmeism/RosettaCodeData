USING: kernel math.combinatorics math.primes.factors sequences ;
: semiprime? ( n -- ? )
    [ factors 2 <combinations> [ product ] map ]
    [ [ = ] curry ] bi any? ;
