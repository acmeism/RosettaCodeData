BEGIN # Multiple Regression - trnslation of the VB.NET sample but using the #
      # "to reduced row echelon form" routine from the Reduced row echelon Task #

    PROC require = ( BOOL condition, STRING message )VOID:
         IF NOT condition THEN
            print( ( message, newline ) );
            stop
         FI # requiree # ;

    MODE MATRIX = STRUCT( REF[,]REAL data
                        , INT row count
                        , INT col count
                        );

    PRIO NEWMATRIX = 1;
    OP   NEWMATRIX = ( INT m rows, INT m cols )MATRIX:
         BEGIN
            MATRIX result;
            require( m rows > 0, "Need at least one row" );
            row count OF result := m rows;
            require( m cols > 0, "Need at least one column" );
            col count OF result := m cols;
            data OF result := HEAP[ 1 : m rows, 1 : m cols ]REAL;
            FOR r TO m rows DO FOR c TO m cols DO ( data OF result )[ r, c ] := 0 OD OD;
            result
         END # NEWMATRIX # ;

    OP   NEWMATRIX = ( [,]REAL source )MATRIX:
         BEGIN
            MATRIX result;
            INT m rows = 1 + ( 1 UPB source - 1 LWB source );
            require( m rows > 0, "Need at least one row" );
            row count OF result := m rows;
            INT m cols = 1 + ( 2 UPB source - 2 LWB source );
            require( m cols > 0, "Need at least one column" );
            col count OF result := m cols;
            data OF result := HEAP[ 1 : m rows, 1 : m cols ]REAL := source[ AT 1, AT 1 ];
            result
         END # NEWMATRIX # ;

    OP   NEWMATRIX = ( []REAL source )MATRIX: # New Matrix(ConvertArray(source)) #
         BEGIN
            INT len = 1 + ( UPB source - LWB source );
            [ 1 : 1, 1 : len ]REAL dest;
            dest[ 1, : ] := source;
            NEWMATRIX dest
         END # NEWMATRIX # ;

    OP   * = ( MATRIX m1, m2 )MATRIX:
         BEGIN
            INT rc1 = row count OF m1;
            INT cc1 = col count OF m1;
            INT rc2 = row count OF m2;
            INT cc2 = col count OF m2;
            require( cc1 = rc2, "Cannot multiply if the first columns does not equal the second rows" );
            MATRIX result := rc1 NEWMATRIX cc2;
            FOR i TO rc1 DO
                FOR j TO cc2 DO
                    FOR k TO rc2 DO
                        ( data OF result ) [ i, j ] +:= ( data OF m1 )[ i, k ]
                                                      * ( data OF m2 )[ k, j ]
                    OD
                OD
            OD;
            result
         END # * # ;

    PROC transpose = ( MATRIX m )MATRIX:
         BEGIN
            INT rc = row count OF m;
            INT cc = col count OF m;
            MATRIX trans := cc NEWMATRIX rc;
            FOR i TO cc DO
                FOR j TO rc DO
                    ( data OF trans )[ i, j ] := ( data OF m )[ j, i ]
                OD
            OD;
            trans
         END # transpose # ;

  # BEGIN code from the Reduced row echelon form task #
    MODE FIELD = REAL; # FIELD can be REAL, LONG REAL etc, or COMPL, FRAC etc #
    MODE VEC = [0]FIELD;
    MODE MAT = [0,0]FIELD;
    PROC to reduced row echelon form = (REF MAT m)VOID: (
        INT lead col := 2 LWB m;

        FOR this row FROM LWB m TO UPB m DO
            IF lead col > 2 UPB m THEN return FI;
            INT other row := this row;
            WHILE m[other row,lead col] = 0 DO
                other row +:= 1;
                IF other row > UPB m THEN
                    other row := this row;
                    lead col +:= 1;
                    IF lead col > 2 UPB m THEN return FI
                FI
            OD;
            IF this row /= other row THEN
                VEC swap = m[this row,lead col:];
                m[this row,lead col:] := m[other row,lead col:];
                m[other row,lead col:] := swap
            FI;
            FIELD scalef = 1/m[this row,lead col];
            IF scalef /= 1 THEN
                m[this row,lead col] := 1;
                FOR col FROM lead col+1 TO 2 UPB m DO m[this row,col] *:= scalef OD
            FI;
            FOR other row pos FROM LWB m TO UPB m DO
                IF this row /= other row pos THEN
                    REAL o scale = m[other row pos,lead col];
                    m[other row pos,lead col]:=0;
                    FOR col FROM lead col+1 TO 2 UPB m DO m[other row pos,col] -:= o scale*m[this row,col] OD
                FI
            OD;
            lead col +:= 1
        OD;
        return: EMPTY
    );
 # END code from the Reduced row echelon form task #

    PROC inverse = ( MATRIX m )MATRIX:
         BEGIN
            require( row count OF m = col count OF m, "Not a square matrix" );
            INT len = row count OF m;
            MATRIX aug := len NEWMATRIX ( 2 * len );
            FOR i TO len DO
                FOR j TO len DO
                    ( data OF aug )[ i, j       ] := ( data OF m )[ i, j ];
                    ( data OF aug )[ i, j + len ] := 0
                OD;
                # augment identity matrix to right #
                ( data OF aug )[ i, i + len ] := 1.0
            OD;
            to reduced row echelon form( data OF aug );
            MATRIX inv := len NEWMATRIX len;
            FOR i TO len DO
                FOR j FROM len + 1 TO 2 * len DO
                    ( data OF inv)[ i, j - len ] := ( data OF aug )[ i, j ]
                OD
            OD;
            inv
         END # inverse # ;

    PROC multiple regression = ( []REAL y, MATRIX x )[]REAL:
         BEGIN
            MATRIX tm := NEWMATRIX y;
            MATRIX cy := NEWMATRIX data OF transpose( tm );
            MATRIX cx := NEWMATRIX data OF transpose( x );
            ( data OF transpose( inverse( x * cx ) * x * cy ) )[ 1, : ]
         END # multiple regression # ;

    OP   PRINTARRAY = ( []REAL list )VOID:
         BEGIN
            print( ( "[" ) );
            FOR i FROM LWB list TO UPB list DO
                # convert list[ i ] to a string, remove trailing 0s and leading spaces #
                STRING v := fixed( list[ i ], -20, 15 )[ AT 1 ];
                WHILE v[ UPB v ] = "0" DO v := v[ : UPB v - 1 ] OD;
                IF v[ UPB v ] = "." THEN v := v[ : UPB v - 1 ] FI;
                WHILE v[ 1 ] = " " DO v := v[ 2 : ] OD;
                print( ( IF i > LWB list THEN ", " ELSE "" FI, v ) )
            OD;
            print( ( "]" ) )
         END # PRINTARRAY # ;

    BEGIN
        []REAL y  = ( 1.0, 2.0, 3.0, 4.0, 5.0 );
        MATRIX x := NEWMATRIX []REAL( 2.0, 1.0, 3.0, 4.0, 5.0 );
        []REAL v  = multiple regression( y, x );
        PRINTARRAY v;
        print( ( newline ) )
    END;
    BEGIN
        []REAL y  = ( 3.0, 4.0, 5.0 );
        MATRIX x := NEWMATRIX [,]REAL( ( 1.0, 2.0, 1.0 )
                                     , ( 1.0, 1.0, 2.0 )
                                     );
        []REAL v  = multiple regression( y, x );
        PRINTARRAY v;
        print( ( newline ) )
    END;
    BEGIN
        []REAL y = ( 52.21, 53.12, 54.48, 55.84, 57.2, 58.57, 59.93
                   , 61.29, 63.11, 64.47, 66.28, 68.1, 69.92, 72.19, 74.46
                   );
        []REAL a = ( 1.47, 1.5, 1.52, 1.55, 1.57, 1.6, 1.63, 1.65
                   , 1.68, 1.7, 1.73, 1.75, 1.78, 1.8, 1.83
                   );
        [ 1 : 3, 1 : 1 + ( UPB a - LWB a ) ]REAL xs;
        FOR i FROM LWB a TO UPB a DO
            xs[ 1, i ] := 1.0;
            xs[ 2, i ] := a[ i ];
            xs[ 3, i ] := a[ i ] * a[ i ]
        OD;
        MATRIX x := NEWMATRIX xs;
        []REAL v  = multiple regression( y, x );
        PRINTARRAY v;
        print( ( newline ) )
    END

END
