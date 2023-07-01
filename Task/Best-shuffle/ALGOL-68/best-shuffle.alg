BEGIN # shuffle a string so as many as possible characters are moved #
    PROC best shuffle = ( STRING orig )STRING:
    BEGIN
        STRING res := orig;
        FOR i FROM LWB orig TO UPB orig DO
            FOR j FROM LWB orig TO UPB orig DO
                IF i /= j AND orig[ i ] /= res[ j ] AND orig[ j ] /= res[ i ] THEN
                    CHAR tmp = res[ i ]; res[ i ] := res[ j ]; res[ j ] := tmp
                FI
            OD
        OD;
        res
    END # best shuffle # ;
    PROC test = ( STRING orig )VOID:
    BEGIN
        STRING res   := best shuffle( orig );
        INT    score := 0;
        FOR i FROM LWB orig TO UPB orig DO
            IF orig[ i ] = res[ i ] THEN
                score +:= 1
            FI
        OD;
        print( ( orig, ", ", res, ", (", whole( score, 0 ), ")", newline ) )
    END # test # ;

    test( "abracadabra" );
    test( "seesaw"      );
    test( "elk"         );
    test( "grrrrrr"     );
    test( "up"          );
    test( "a"           )
END
