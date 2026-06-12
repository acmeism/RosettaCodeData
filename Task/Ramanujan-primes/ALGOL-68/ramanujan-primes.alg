BEGIN # find some Ramanujan primes: the nth Ramanujan prime is the least n   #
      # such that there are at least n primes between x and x/2 for all x>=n #
    PR read "primes.incl.a68" PR               # include the prime utilities #
    []BOOL p = PRIMESIEVE 1 000 000;            # generate a sieve of primes #
    # find the highest numbers where the number of primes between x and x/2  #
    # is at most n, store the list in hpx                                    #
    [ 0 : UPB p ]INT hpx;
    BEGIN
        # count the primes up to n                                           #
        [ 0 : UPB p ]INT pc;              # pc[ n ]: count of primes up to n #
        FOR i FROM LWB pc TO UPB pc DO pc[ i ] := 0 OD;
        INT p count := 0;
        FOR i TO UPB pc DO
            IF p[ i ] THEN p count +:= 1 FI;
            pc[ i ] := p count
        OD;
        # count the pimes between x and x/2                                  #
        [ 0 : UPB p ]INT pc2;  # pc2[ n ]: count of primes between n and n/2 #
        FOR i FROM LWB pc2 TO UPB pc2 DO
            pc2[ i ] := pc[ i ] - pc[ i OVER 2 ]
        OD;
        # find the highest x where the prime count between x and x/2 is x    #
        FOR i FROM LWB hpx TO UPB hpx DO hpx[ i ] := 0 OD;
        FOR i FROM LWB hpx TO UPB hpx DO
            hpx[ pc2[ i ] ] := i
        OD
    END;
    # show the Ramanjan primes                                               #
    INT r count     := 0;
    INT power of 10 := 1 000;
    FOR n FROM LWB hpx TO UPB hpx WHILE r count < 10 000 DO
        # hpx[ n ] contains the highest number where the number of primes    #
        # between x and x/2 is at most n, so we need to find the next        #
        # prime >= n                                                         #
        INT rp := hpx[ n ];
        WHILE NOT p[ rp ] DO rp +:= 1 OD;
        IF ( r count +:= 1 ) <= 100 THEN
            print( ( " ", whole( rp, -4 ) ) );
            IF r count MOD 20 = 0 THEN print( ( newline ) ) FI
        ELIF r count = power of 10 THEN
            print( ( "The ", whole( r count, -8 ), "th Ramanujan prime is: ", whole( rp, 0 ), newline ) );
            power of 10 *:= 10
        FI
    OD
END
