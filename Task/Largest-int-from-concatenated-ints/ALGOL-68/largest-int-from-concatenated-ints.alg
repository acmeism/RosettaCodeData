BEGIN
    OP TOINT = ( STRING s)INT:
    BEGIN
        INT result := 0;
        FOR s pos FROM LWB s TO UPB s DO
            result *:= 10 +:= ( ABS s[ s pos ] - ABS "0" )
        OD;
        result
    END # TOINT # ;
    OP TOSTRING = ( INT n )STRING: whole( n, 0 );
    OP PRINT = ( []INT a )VOID:
       FOR a pos FROM LWB a TO UPB a DO
            print( ( TOSTRING a[ a pos ] ) )
       OD # PRINT # ;

    # returns an array containing the values of a sorted such that           #
    #         concatenating the values would result in the largest value     #
    OP CONCATSORT = ( []INT a )[]INT:
       IF LWB a >= UPB a THEN                            # 0 or 1 element(s) #
           a
       ELSE                                             # 2 or more elements #
           [ 1 : ( UPB a - LWB a ) + 1 ]INT result := a[ AT 1 ];
           # re-order adjacent numbers so they have the highest concatenated #
           WHILE BOOL swapped := FALSE;                              # value #
                 FOR i pos TO UPB result - 1 DO
                     STRING l := TOSTRING result[ i pos     ];
                     STRING r := TOSTRING result[ i pos + 1 ];
                     IF TOINT ( l + r ) < TOINT ( r + l ) THEN
                         INT t = result[ i pos + 1 ];
                         result[ i pos + 1 ] := result[ i pos ];
                         result[ i pos     ] := t;
                         swapped             := TRUE
                     FI
                 OD;
                 swapped
           DO SKIP OD;
           result
       FI # CONCATSORT # ;

    # task test cases #
    PRINT CONCATSORT []INT( 1, 34, 3, 98, 9, 76, 45, 4 );
    print( ( newline ) );
    PRINT CONCATSORT []INT( 54, 546, 548, 60 );
    print( ( newline ) )

END
