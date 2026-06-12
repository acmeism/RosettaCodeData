BEGIN # Factorize a string into Lyndon words - translated of the Python sample #

    PROC chen fox lyndon factorization = ( STRING s )[]STRING:
         BEGIN
            INT n  = UPB s;
            INT i := LWB s;
            FLEX[ 1 : 100 ]STRING factorization;
            INT f max := LWB factorization;
            WHILE i <= n DO
                INT j := i + 1, k := i;
                WHILE IF j <= n THEN s[ k ] <= s[ j ] ELSE FALSE FI DO
                    IF s[ k ] < s[ j ] THEN
                        k  := i
                    ELSE
                        k +:= 1
                    FI;
                    j +:= 1
                OD;
                WHILE i <= k DO
                    f max +:= 1;
                    IF f max > UPB factorization THEN
                        [ 1 : UPB factorization + 20 ]STRING new factorization;
                        new factorization[ 1 : UPB factorization ] := factorization;
                        factorization := new factorization
                    FI;
                    factorization[ f max ] := s[ i : i + j - k - 1 ];
                    i +:= j - k
                OD
            OD;
            STRING check := "";
            FOR j TO f max DO check +:= factorization[ j ] OD;
            IF check /= s THEN print( ( "Incorrect factorization", newline ) ); stop FI;
            factorization[ 1 : f max ]
         END # chen fox lyndon factorization # ;

    # Example use with Thue-Morse sequence                                     #
    STRING m := "0";
    TO 7 DO
         STRING m0 = m;
         FOR i FROM LWB m TO UPB m DO
             IF m[ i ]  = "0" THEN m[ i ] := "1" ELIF m[ i ]  = "1" THEN m[ i ] := "0" FI
         OD;
         m0 +=: m
    OD;

    []STRING m factors = chen fox lyndon factorization( m );
    FOR i FROM LWB m factors TO UPB m factors DO
        print( ( m factors[ i ], newline ) )
    OD

END
