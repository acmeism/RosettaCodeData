BEGIN # sieve of Sundaram #
    INT n = 8 000 000;
    INT none = 0, mark1 = 1, mark2 = 2;
    [ 1 : n ]INT mark;
    FOR i FROM LWB mark TO UPB mark DO mark[ i ] := none  OD;
    FOR i FROM   4 BY 3 TO UPB mark DO mark[ i ] := mark1 OD;

    INT            count := 0; # Count of primes.          #
    [ 1 : 100 ]INT list100;    # First 100 primes.         #
    INT            last  := 0; # Millionth prime.          #
    INT            step  := 5; # Current step for marking. #

    FOR i TO n WHILE last = 0 DO
        IF mark[ i ] = none THEN # Add/count a new odd prime.  #
            count +:= 1;
            IF   count <= 100 THEN
                list100[ count ] := 2 * i + 1
            ELIF count = 1 000 000 THEN
                last := 2 * i + 1
            FI
        ELIF mark[ i ] = mark1 THEN # Mark new numbers using current step. #
            IF i > 4 THEN
                FOR k FROM i + step BY step TO n DO
                    IF mark[ k ] = none THEN mark[ k ] := mark2 FI
                OD;
                step +:= 2
            FI
      # ELSE must be mark2 - Ignore this number. #
        FI
    OD;

    print( ( "First 100 Sundaram primes:", newline ) );
    FOR i FROM LWB list100 TO UPB list100 DO
        print( ( whole( list100[ i ], -3 ) ) );
        IF i MOD 10 = 0 THEN print( ( newline ) ) ELSE print( ( " " ) ) FI
    OD;
    print( ( newline ) );
    IF last = 0 THEN
        print( ( "Not enough values in sieve. Found only ", whole( count, 0 ), newline ) )
    ELSE
        print( ( "The millionth Sundaram prime is ", whole( last, 0 ), newline ) )
    FI
END
