BEGIN # find primes where all substrings of the digits are prime #
    # find the primes of interest #
    PR read "primes.incl.a68" PR
    []BOOL prime = PRIMESIEVE 500;
    FOR p TO UPB prime DO
        IF prime[ p ] THEN
            INT d := 10;
            BOOL is substring := TRUE;
            WHILE is substring AND d <= UPB prime DO
                INT n := p;
                WHILE is substring AND n > 0 DO
                    is substring := prime[ n MOD d ];
                    n OVERAB 10
                OD;
                d *:= 10
            OD;
            IF is substring THEN print( ( " ", whole( p, 0 ) ) ) FI
        FI
    OD
END
