BEGIN # find some Fermat pseudo primes: x is a Fermat pseudoprime in base a   #
      # if a^(x-1) - 1 is divisible by x and x is not prime                   #

    # iterative Greatest Common Divisor routine, returns the gcd of m and n   #
    PROC gcd = ( INT m, n )INT:
         BEGIN
            INT a := ABS m, b := ABS n;
            WHILE b /= 0 DO
                INT new a = b;
                b        := a MOD b;
                a        := new a
            OD;
            a
        END # gcd # ;
    [ 0 : 50 000 ]BOOL prime;
    prime[ 0 ] := prime[ 1 ] := FALSE;
    prime[ 2 ] := TRUE;
    FOR i FROM 3 BY 2 TO UPB prime DO prime[ i ] := TRUE  OD;
    FOR i FROM 4 BY 2 TO UPB prime DO prime[ i ] := FALSE OD;
    FOR i FROM 3 BY 2 TO ENTIER sqrt( UPB prime ) DO
        IF prime[ i ] THEN
            FOR s FROM i * i BY i + i TO UPB prime DO prime[ s ] := FALSE OD
        FI
    OD;
    FOR base FROM 1 TO 20 DO
        [ 1 : 20 ]INT fp;
        INT count := 0;
        # x from 3 as 1 is neither composite nor prime and 2 is prime         #
        IF base = 1 THEN
            # 1^(x-1) is 1 for all x, so all composites are                   #
            # fermat pseudo primes in base 1                                  #
            FOR x FROM 3 TO UPB prime DO
                IF NOT prime[ x ] THEN
                    IF ( count +:= 1 ) <= UPB fp THEN
                        fp[ count ] := x
                    FI
                FI
            OD
        ELSE
            # must test base^(x-1) mod x                                      #
            FOR x FROM 3 BY IF ODD base THEN 1 ELSE 2 FI TO UPB prime DO
                IF NOT prime[ x ] THEN
                    IF gcd( x, base ) = 1 THEN
                        # have a composite x co-prime to the base             #
                        INT base to x minus 1 mod x := 1;
                        FOR p TO x - 1
                        WHILE
                            base to x minus 1 mod x *:= base MODAB x;
                            IF base to x minus 1 mod x = 1
                            THEN # the power is now 1 mod x,                  #
                                 # if the power divides x - 1 then base^(x-1) #
                                 # will be 1 mod x otherwise it won't be      #
                                 IF ( x - 1 ) MOD p /= 0 THEN
                                     base to x minus 1 mod x := 0
                                 FI;
                                 FALSE
                            ELSE TRUE # keep checking the powers              #
                            FI
                        DO SKIP OD;
                        IF base to x minus 1 mod x = 1 THEN
                            # have a composite x that divides base^(x-1)-1    #
                            IF ( count +:= 1 ) <= UPB fp THEN
                                fp[ count ] := x
                            FI
                        FI
                    FI
                FI
            OD
        FI;
        print( ( "base ", whole( base, -2 ), " to ", whole( UPB prime, 0 )
               , " total: ", whole( count, 0 ), newline, "     first:"
               )
             );
        FOR f FROM LWB fp TO IF count < UPB fp THEN count ELSE UPB fp FI DO
            print( ( " ", whole( fp[ f ], 0 ) ) )
        OD;
        print( ( newline ) )
    OD
END
