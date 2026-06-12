BEGIN # find multiplicatively perfect numbers - numbers whose proper         #
      # divisor product is the number itself ( includes 1 )                  #
    PR read "primes.incl.a68" PR          # include prime utilties           #
    INT max number = 500 000;             # largest number we wlil consider  #
    []BOOL prime = PRIMESIEVE max number; # sieve the primes to max number   #
    [ 1 : max number ]INT pdc;            # table of proper divisor counts   #
    [ 1 : max number ]INT pfc;            # table of prime factor counts     #
    # count the proper divisors and prime factors                            #
    FOR n TO UPB pdc DO pdc[ n ] := 1; pfc[ n ] := 0 OD;
    FOR i FROM 2 TO UPB pdc DO
        INT m := 1;                       # j will be the mth multiple of i  #
        FOR j FROM i + i BY i TO UPB pdc DO
            pdc[ j ] +:= 1;
            IF prime[ m +:= 1 ] THEN      # j is a prime multiple of i       #
               pfc[ j ] +:= 1;
               IF i = m THEN              # j is i squared                   #
                  pfc[ j ] +:= 1
               FI
            ELSE                          # j is not a prime multiple of i   #
               pfc[ j ] +:= pfc[ m ]      # add the prime factor count of m  #
            FI
        OD
    OD;
    # find the mutiplicatively perfect numbers                               #
    INT mp count     :=   0;
    INT sp count     :=   0;
    INT next to show := 500;
    FOR n TO UPB pdc DO
        IF n = 1 OR pdc[ n ] = 3 THEN
            # n is 1 or has 3 proper divisors so is multiplicatively perfect #
            # number - see OEIS A007422                                      #
            mp count +:= 1;
            IF n < 500 THEN
                print( ( " ", whole( n, -3 ) ) );
                IF mp count MOD 10 = 0 THEN print( ( newline ) ) FI
            FI
        FI;
        IF pfc[ n ] = 2 THEN
            # 2 prime factors, n is semi-prime                               #
            sp count +:= 1
        FI;
        IF n = next to show THEN
            print( ( "Up to ", whole( next to show, -8 )
                   , " there are ", whole( mp count, -6 )
                   , " multiplicatively perfect numbers and ", whole( sp count, -6 )
                   , " semi-primes", newline
                   )
                 );
            next to show *:= 10
        FI
    OD
END
