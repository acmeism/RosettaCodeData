BEGIN # polynomial synthetic division - translation of Kotlin #

    OP   LEN    = ( []INT a )INT: ( UPB a - LWB a ) + 1;
    MODE QRPAIR = STRUCT( [ 1 : 0 ]INT q, r );
    PROC extended synthetic division = ( []INT dividend, divisor in )QRPAIR:
         BEGIN
            [ 0 : LEN dividend - 1 ]INT out := dividend[ AT 0 ];
            []INT divisor = divisor in[ AT 0 ];
            INT dividend size = LEN dividend;
            INT divisor size  = LEN divisor;
            INT normalizer    = divisor[ 0 ];
            INT separator     = dividend size - divisor size + 1;
            FOR i FROM 0 TO separator - 1 DO
                out[ i ] OVERAB normalizer;
                IF  INT coef = out[ i ];
                    coef /= 0
                THEN
                    FOR j FROM 1 TO UPB divisor DO out[ i + j ] -:= divisor[ j ] * coef OD
                FI
            OD;
            ( out[ : separator - 1 ], out[ separator : ] )
         END # extended synthetic division # ;

    OP   SHOWPOLYNOMIAL = ( []INT p )VOID:
         BEGIN
            BOOL first := TRUE;
            INT  power := LEN p - 1;
            FOR i FROM LWB p TO UPB p DO
                IF INT e = p[ i ];
                   e /= 0
                THEN
                    print( ( IF   e < 0 AND first THEN "-"
                             ELIF e < 0           THEN " - "
                             ELIF           first THEN ""
                             ELSE                      " + "
                             FI
                           , IF ABS e = 1 AND power > 0 THEN "" ELSE whole( ABS e, 0 ) FI
                           )
                         );
                    IF power > 0 THEN
                        print( ( "x" ) );
                        IF power > 1 THEN print( ( "^", whole( power, 0 ) ) ) FI
                    FI;
                    first  := FALSE
                FI;
                power -:= 1
            OD;
            IF first THEN
                print( ( "(negative degree)" ) )
            FI
         END # SHOWPOLYNOMIAL # ;

    BEGIN
        PROC test = ( []INT n, d )VOID:
             BEGIN
                QRPAIR qr = extended synthetic division( n, d );
                SHOWPOLYNOMIAL n; print( ( " / " ) ); SHOWPOLYNOMIAL d; print( ( "     ->     " ) );
                SHOWPOLYNOMIAL q OF qr; print( ( ", remainder " ) ); SHOWPOLYNOMIAL r OF qr;
                print( ( newline ) )
             END # test # ;
        print( ( "POLYNOMIAL SYNTHETIC DIVISION", newline ) );
        test( (    1, -12, 0, -42 ), (       1, -3 ) );
        print( ( newline ) );
        test( ( 1, 0,   0, 0,  -2 ), ( 1, 1, 1,  1 ) )
    END
END
