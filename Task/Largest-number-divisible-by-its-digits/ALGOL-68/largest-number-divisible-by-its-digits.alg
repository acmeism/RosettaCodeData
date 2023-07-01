BEGIN # find the largest decimal integer with unique digits, divisible by its digits #
    INT magic   = 9 * 8 * 7; # see analysis in the Raku sample #
    INT high    = ( 9876432 OVER magic ) * magic;
    BOOL found := FALSE;
    FOR i FROM high BY - magic TO magic WHILE NOT found DO
        IF   INT d1 = i MOD 10;
             d1 = 0
        THEN SKIP # can't end in '0' #
        ELIF [ 0 : 9 ]BOOL digits :=
                 []BOOL( FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE )[ @ 0 ];
             BOOL unique  := TRUE;
             INT  v       := i OVER 10;
             digits[ d1 ] := TRUE;
             WHILE v > 0 AND unique DO
                 INT d = v MOD 10;
                 v OVERAB 10;
                 unique      := NOT digits[ d ];
                 digits[ d ] := TRUE
             OD;
             NOT unique
        THEN SKIP # digits must be unique #
        ELIF digits[ 0 ] OR digits[ 5 ]
        THEN SKIP # can't contain 0 or 5 #
        ELIF found := TRUE;
             FOR d TO UPB digits WHILE found DO
                 IF digits[ d ] THEN found := i MOD d = 0 FI
             OD;
             found
        THEN
             print( ( "Largest decimal number is ", whole( i, 0 ), newline ) )
        FI
    OD
END
