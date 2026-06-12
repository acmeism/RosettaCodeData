BEGIN # find a adjacent primes where the primes differ by a square > 36 #
    INT min diff  = 37;
    INT max prime = 1 000 000;
    PR read "primes.incl.a68" PR
    # form a list of primes to max prime #
    []INT prime = EXTRACTPRIMESUPTO max prime FROMPRIMESIEVE PRIMESIEVE max prime;
    # construct a table of squares, we will need at most the square root of max prime #
    # but in reality much less than that - assume 1000 will be enough #
    [ 1 : 1000 ]BOOL is square;
    FOR i TO UPB is square DO is square[ i ] := FALSE OD;
    FOR i TO ENTIER sqrt( UPB is square ) DO is square[ i * i ] := TRUE OD;
    # find the primes #
    FOR p TO UPB prime - 1 DO
        INT q    = p + 1;
        INT diff = prime[ q ] - prime[ p ];
        IF diff > min diff AND is square[ diff ] THEN
            print( ( whole( prime[ q ], -6 ), " - ", whole( prime[ p ], -6 ), " = ", whole( diff, 0 ), newline ) )
        FI
    OD
END
