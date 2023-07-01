BEGIN # find some untouchable numbers - numbers not equal to the sum of the   #
      # proper divisors of any +ve integer                                    #
    INT max untouchable = 1 000 000;
    # a table of the untouchable numbers                                      #
    [ 1 : max untouchable ]BOOL untouchable; FOR i TO UPB untouchable DO untouchable[ i ] := TRUE OD;
    # show the counts of untouchable numbers found                            #
    PROC show untouchable statistics = VOID:
         BEGIN
            print( ( "Untouchable numbers:", newline ) );
            INT u count := 0;
            FOR i TO UPB untouchable DO
                IF untouchable[ i ] THEN u count +:= 1 FI;
                IF i =        10
                OR i =       100
                OR i =     1 000
                OR i =    10 000
                OR i =   100 000
                OR i = 1 000 000
                THEN
                    print( ( whole( u count, -7 ), " to ", whole( i, -8 ), newline ) )
                FI
            OD
         END; # show untouchable counts #
    # prints the untouchable numbers up to n                                  #
    PROC print untouchables = ( INT n )VOID:
         BEGIN
            print( ( "Untouchable numbers up to ", whole( n, 0 ), newline ) );
            INT u count := 0;
            FOR i TO n DO
                IF untouchable[ i ] THEN
                    print( ( whole( i, -4 ) ) );
                    IF u count +:= 1;
                       u count MOD 16 = 0
                    THEN print( ( newline ) )
                    ELSE print( ( " " ) )
                    FI
                FI
            OD;
            print( ( newline ) );
            print( ( whole( u count, -7 ), " to ", whole( n, -8 ), newline ) )
         END; # print untouchables #
    # find the untouchable numbers                                            #
    # to find untouchable numbers up to e.g.: 10 000, we need to sieve up to  #
    # 10 000 ^2 i.e. 100 000 000                                              #
    # however if we also use the facts that no untouchable = prime + 1        #
    # and no untouchable = odd prime + 3 and 5 is (very probably) the only    #
    # odd untouchable, other samples suggest we can use limit * 64 to find    #
    # untlouchables up to 1 000 000 - experimentation reveals this to be true #
    # assume the conjecture that there are no odd untouchables except 5       #
    BEGIN
        untouchable[ 1 ] := FALSE;
        untouchable[ 3 ] := FALSE;
        FOR i FROM 7 BY 2 TO UPB untouchable DO untouchable[ i ] := FALSE OD
    END;
    # sieve the primes to max untouchable and flag the non untouchables       #
    BEGIN
        PR read "primes.incl.a68" PR
        []BOOL prime = PRIMESIEVE max untouchable;
        FOR i FROM 3 BY 2 TO UPB prime DO
            IF prime[ i ] THEN
                IF i < max untouchable THEN
                    untouchable[ i + 1 ] := FALSE;
                    IF i < ( max untouchable - 2 ) THEN
                        untouchable[ i + 3 ] := FALSE
                    FI
                FI
            FI
        OD;
        untouchable[ 2 + 1 ] := FALSE # special case for the only even prime  #
    END;
    # construct the proper divisor sums and flag the non untouchables         #
    BEGIN
        [ 1 : max untouchable * 64 ]INT spd;
        FOR i TO UPB spd DO spd[ i ] := 1 OD;
        FOR i FROM 2 TO UPB spd DO
            FOR j FROM i + i BY i TO UPB spd DO spd[ j ] +:= i OD
        OD;
        FOR i TO UPB spd DO
            IF spd[ i ] <= UPB untouchable THEN untouchable[ spd[ i ] ] := FALSE FI
        OD
    END;
    # show the untouchable numbers up to 2000                                 #
    print untouchables( 2 000 );
    # show the counts of untouchable numbers                                  #
    show untouchable statistics
END
