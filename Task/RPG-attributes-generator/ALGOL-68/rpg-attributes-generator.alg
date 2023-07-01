BEGIN # RPG attributes generator #

    INT attrib count = 6;
    MODE RESULT = STRUCT( BOOL success, INT sum, high count, [ 1 : attrib count ]INT a );

    PROC generate attrib = INT:
    BEGIN
        INT min := 255, sum := 0;
        FOR i FROM 0 TO 3 DO
            INT v = ENTIER( next random * 6 ) + 1;
            IF v < min THEN
                min := v
            FI;
            sum +:= v
        OD;
        sum - min
    END # generate attrib #;

    PROC generate = ( REF RESULT res )VOID:
    BEGIN
        high count OF res := 0;
        sum OF res        := 0;
        FOR i FROM LWB a OF res TO UPB a OF res DO
            INT v = generate attrib;
            IF v >= 15 THEN
               high count OF res +:= 1
            FI;
            sum OF res +:= v;
            ( a OF res )[ i ] := v
        OD;
        success OF res := ( high count OF res >= 2 AND sum OF res >= 75 )
    END # generate # ;

    RESULT res;
    success OF res := FALSE;
    WHILE NOT success OF res DO
        generate( res );
        print( ( "attribs: " ) );
        FOR i FROM LWB a OF res TO UPB a OF res DO
            print( ( whole( ( a OF res )[ i ], 0 ) ) );
            IF i < UPB a OF res THEN
                print( ( " " ) )
            FI
        OD;
        print( ( " sum=", whole( sum OF res, 0 )
               , " highCount=", whole( high count OF res, 0 )
               , " ", IF success OF res THEN "success" ELSE "failed" FI
               , newline
               )
             )
    OD

END
