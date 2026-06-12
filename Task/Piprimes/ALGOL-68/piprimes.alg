BEGIN # Show some values of pi(n) - the number of priems <= n  #
    # show pi(n) for n up to 21 #
    INT max prime = 100; # guess of how large the primes we need are #
    INT max pi    = 21;
    PR read "primes.incl.a68" PR
    []BOOL prime  = PRIMESIEVE max prime;
    INT pi count := 0;
    FOR i TO UPB prime
    WHILE IF prime[ i ] THEN pi count +:= 1 FI;
          pi count <= max pi
    DO
        print( ( " ", whole( pi count, -2 ) ) );
        IF i MOD 10 = 0 THEN print( ( newline ) ) FI
    OD;
    print( ( newline ) )
END
