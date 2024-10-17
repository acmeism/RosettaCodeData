BEGIN # de Bruijn sequences - translation of the Phix sample                 #

    HEAP[ 1 : 6000 ]CHAR initial sequence;
    REF[]CHAR de bruijn := initial sequence;      # will increase in size as #
                                                                    # needed #
    INT s len := 0;                         # current length of the sequence #
    # adds v to the de Bruijn sequence, extending it if necessary            #
    PROC add element = ( INT v )VOID:
         BEGIN
            s len +:= 1;
            IF s len > UPB de bruijn THEN
                HEAP[ 1 : UPB de bruijn + 6000 ]CHAR new sequence;
                new sequence[ 1 : UPB de bruijn ] := de bruijn;
                de bruijn                         := new sequence
            FI;
            de bruijn[ s len ] := REPR ( ABS "0" + v )
         END # add element # ;

    FOR n FROM 0 TO 99 DO                           # construct the sequence #
        INT a1 = n OVER 10;
        INT a2 = n MOD  10;
        IF a2 >= a1 THEN
            add element( a1 );
            IF a1 /= a2 THEN add element( a2 ) FI;
            FOR m FROM n + 1 TO 99 DO
                INT m2 = m MOD 10;
                IF m2 > a1 THEN
                    add element( a1 );
                    add element( a2 );
                    add element( m OVER 10 );
                    add element( m2 )
                FI
            OD
        FI
    OD;
    add element( 0 ); add element( 0 ); add element( 0 );
    de bruijn := de bruijn[ 1 : s len ];

    print( ( "de Bruijn sequence length: ", whole( s len, 0 ), newline, newline ) );
    print( ( "First 130 characters:", newline ) );
    FOR i TO 130 DO print( ( de bruijn[ i ] ) ) OD; print( ( newline, newline ) );
    print( ( "Last 130 characters:", newline ) );
    FOR i FROM s len - 129 TO s len DO print( ( de bruijn[ i ] ) ) OD; print( ( newline, newline ) );

    # checks all pins are in the sequence, returns the ones that aren't      #
    PROC check = ( []CHAR sequence )STRING:
         BEGIN
            # returns TRUE if "0" <= c <= "9", FALSE otherwise               #
            OP ISDIGIT = ( CHAR c )BOOL: c >= "0" AND c <= "9";
            # returns c converted to an integer, assumes "0" <= c <= "9"     #
            OP DIGIT = ( CHAR c )INT: ABS c - ABS "0";
            [ 0 : UPB sequence - 3 ]INT found; FOR i FROM LWB found TO UPB found DO found[ i ] := 0 OD;
            STRING res := "";
            FOR i TO UPB found DO
                IF  ISDIGIT sequence[ i     ] AND ISDIGIT sequence[ i + 1 ]
                AND ISDIGIT sequence[ i + 2 ] AND ISDIGIT sequence[ i + 3 ]
                THEN
                    INT k :=     DIGIT sequence[ i     ];
                    k *:= 10 +:= DIGIT sequence[ i + 1 ];
                    k *:= 10 +:= DIGIT sequence[ i + 2 ];
                    k *:= 10 +:= DIGIT sequence[ i + 3 ];
                    IF k >= LWB found AND k <= UPB found THEN found[ k ] +:= 1 FI
                FI
            OD;
            INT errors := 0;
            FOR i FROM LWB found TO UPB found - 1 DO
                IF   INT k = found[ i ];
                     k /= 1
                THEN STRING e := whole( i, -4);
                     FOR j FROM LWB e TO UPB e DO IF e[ j ] = " " THEN e[ j ] := "0" FI OD;
                     "Pin number " +=: e;
                     e +:= IF k = 0
                           THEN " missing"
                           ELSE " occurs " + whole( k, 0 ) + " times"
                           FI;
                     res    +:= e + REPR 10;
                     errors +:= 1
                FI
            OD;
            IF errors = 0 THEN
                res := "No errors found"
            ELSE
                STRING prefix := whole( errors, 0 ) + " error";
                IF errors > 1 THEN prefix +:= "s" FI;
                prefix +:= " found" + REPR 10;
                prefix +=: res
            FI;
            res
         END # check # ;

    print( ( "Missing 4 digit PINs in this sequence: ", check( de bruijn ), newline ) );
    [ 1 : UPB de bruijn ]CHAR reversed;
    INT r pos := 0;
    FOR i FROM UPB de bruijn BY -1 TO 1 DO reversed[ r pos +:= 1 ] := de bruijn[ i ] OD;
    print( ( "Missing 4 digit PINs in the reversed sequence: ", check( reversed ), newline ) );
    print( ( newline, "4444th digit in the sequence: ", de bruijn[ 4444 ] ) );
    print( ( " (setting it to ""."")", newline ) );
    de bruijn[ 4444 ] := ".";
    print( ( "Re-running checks: ", check( de bruijn ), newline ) )

END
