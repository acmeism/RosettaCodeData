BEGIN # find the maximum difference between consecutive list elements         #
    # returns the maximum difference between pairs of elements of list        #
    OP   MAXDELTA = ( []REAL list )REAL:
         BEGIN
            REAL max diff := 0;
            FOR i FROM LWB list TO UPB list - 1 DO
                REAL delta = ABS ( list[ i ] - list[ i + 1 ] );
                IF delta > max diff THEN
                    max diff := delta # found a higher difference             #
                FI
            OD;
            max diff
         END; # MAXDELTA #
    # returns r converted to a string with trailing 0 decimal places removed  #
    OP   TOSTRING = ( REAL r )STRING:
         BEGIN
            STRING result  := fixed( r, 0, 10 );
            IF result[ LWB result ] = "." THEN result := "0" + result FI;
            INT    r end   := UPB result;
            INT    r start := LWB result;
            WHILE IF r end <= r start THEN FALSE ELSE result[ r end ] = "0" FI DO
               r end -:= 1
            OD;
            IF r end > LWB result THEN
                # if all decimal places were "0", remove the "." as well      #
                IF result[ r end ] = "." THEN r end -:= 1 FI
            FI;
            result[ r start : r end ]
         END; # TOSTRING #
    # test the MAXDELTA operator                                              #
    PROC test max delta = ( []REAL list )VOID:
         BEGIN
            REAL max diff = MAXDELTA list;
            print( ( "Max difference [" ) );
            FOR i FROM LWB list TO UPB list DO
                print( ( " ", TOSTRING list[ i ] ) )
            OD;
            print( ( " ] is ", TOSTRING max diff, ":",  newline ) );
            FOR i FROM LWB list TO UPB list - 1 DO
                IF REAL diff = ABS ( list[ i ] - list[ i + 1 ] );
                   diff = max diff
                THEN
                    print( ( "    ", TOSTRING list[ i ], ", ", TOSTRING list[ i + 1 ]
                           , " ==> ", TOSTRING diff
                           , newline
                           )
                         )
                FI
            OD
         END; # test max delta #
    # task test case                                                          #
    test max delta( ( 1, 8, 2, -3, 0, 1, 1, -2.3, 0, 5.5, 8, 6, 2, 9, 11, 10, 3 ) );
    # additional test cases                                                   #
    test max delta( ( -1.1, -1.2 ) ); test max delta( ( pi, pi, pi ) );
    test max delta( ( )            ); test max delta( ( 776.591 )    )
END
