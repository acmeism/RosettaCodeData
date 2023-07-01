BEGIN # find members of the sequence a(n) = smallest k such that 2^(2^n) - k is prime #
    PR precision 650 PR # set number of digits for LONG LOMG INT       #
                        # 2^(2^10) has 308 digits but we need more for #
                        # Miller Rabin primality testing               #
    PR read "primes.incl.a68" PR # include the prime related utilities #
    FOR n TO 10 DO
        LONG LONG INT two up 2 up n = LONG LONG INT( 2 ) ^ ( 2 ^ n );
        FOR i BY 2
        WHILE IF is probably prime( two up 2 up n - i ) THEN
                  # found a sequence member #
                  print( ( " ", whole( i, 0 ) ) );
                  FALSE # stop looking #
              ELSE
                  TRUE # haven't found a sequence member yet #
              FI
        DO SKIP OD
    OD
END
