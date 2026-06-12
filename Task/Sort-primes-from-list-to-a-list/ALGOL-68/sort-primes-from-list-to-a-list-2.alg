BEGIN # sort primes from a list to a list - translation of EasyLang #

    PROC is prime = ( INT n )BOOL:
         IF   n < 2 THEN FALSE
         ELIF NOT ODD n THEN n = 2
         ELSE
            INT root n = ENTIER sqrt( n );
            BOOL result := TRUE;
            FOR i FROM 3 BY 2 TO root n WHILE result := n MOD i /= 0 DO SKIP OD;
            result
         FI # is prime # ;

    PROC insert = ( INT v, REF[]INT d, REF INT d pos )VOID:
         BEGIN
            INT i pos := d pos;
            d pos +:= 1;
            IF i pos > LWB d THEN
                WHILE i pos > LWB d AND d[ i pos ] > v DO
                    d[ i pos + 1 ] := d[ i pos ];
                    i pos -:= 1
                OD
            FI;
            d[ i pos + 1 ] := v
         END # insert # ;

    []INT list = ( 2, 43, 81, 122, 63, 13, 7, 95, 103 );
    [ LWB list : UPB list ]INT sorted primes;
    INT prime pos := LWB list - 1;
    FOR l pos FROM LWB list TO UPB list DO
        INT p = list[ l pos ];
        IF is prime( p ) THEN insert( p, sorted primes, prime pos ) FI
    OD;
    FOR l pos FROM LWB sorted primes TO prime pos DO
        print( ( " ", whole( sorted primes[ l pos ], 0 ) ) )
    OD;
    print( ( newline ) )

END
