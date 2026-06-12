BEGIN # sum primes up to 2 000 000 #
    PR read "primes.incl.a68" PR
    # return s space-separated into groups of 3 digits #
    PROC space separate = ( STRING unformatted )STRING:
         BEGIN
            STRING result      := "";
            INT    ch count    := 0;
            FOR c FROM UPB unformatted BY -1 TO LWB unformatted DO
                IF   ch count <= 2 THEN ch count +:= 1
                ELSE                    ch count  := 1; " " +=: result
                FI;
                unformatted[ c ] +=: result
            OD;
            result
         END # space separate # ;
    # sum the primes #
    []BOOL prime = PRIMESIEVE 2 000 000;
    LONG INT sum := 2;
    FOR i FROM 3 BY 2 TO UPB prime DO
        IF prime[ i ] THEN
            sum +:= i
        FI
    OD;
    print( ( space separate( whole( sum, 0 ) ), newline ) )
END
