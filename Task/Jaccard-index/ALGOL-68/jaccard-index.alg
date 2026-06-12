BEGIN # calculate the Jaccard index of some sets                             #

    # returns TRUE if v is in s, FALSE otherwise                             #
    PRIO CONTAINS = 1;
    OP   CONTAINS = ( []INT s, INT v )BOOL:
         BEGIN
            BOOL found := FALSE;
            FOR i FROM LWB s TO UPB s WHILE NOT ( found := s[ i ] = v ) DO SKIP OD;
            found
         END # CONTAINS # ;
    # returns TRUE if v is not in s, FALSE if it is                          #
    PRIO NOTIN = 1;
    OP   NOTIN = ( INT v, []INT s )BOOL: NOT ( s CONTAINS v );

    # returns the Jaccard index of a and b                                   #
    PRIO JACCARD = 1;
    OP   JACCARD = ( []INT a, []INT b )REAL:
         IF LWB a > UPB a AND LWB b > UPB b
         THEN 1 # both sets are empty #
         ELSE INT i count := 0, u count := 0;
              FOR i FROM LWB a TO UPB a DO
                  u count +:= 1;
                  IF b CONTAINS a[ i ] THEN i count +:= 1 FI
              OD;
              FOR i FROM LWB b TO UPB b DO
                  IF b[ i ] NOTIN a THEN u count +:= 1 FI
              OD;
              i count / u count
         FI # JACCARD # ;

    [][]INT  sets  = ( []INT( () )
                     , ( 1, 2, 3, 4,  5 )
                     , ( 1, 3, 5, 7,  9 )
                     , ( 2, 4, 6, 8, 10 )
                     , ( 2, 3, 5, 7 )
                     , []INT( 8 )
                     );
    []STRING names = ( "A", "B", "C", "D", "E", "F" );
    print( ( "  " ) );
    FOR n FROM LWB names TO UPB names DO print( ( "      ", names[ n ] ) ) OD;
    print( ( newline ) );
    FOR s1 FROM LWB sets TO UPB sets DO
        print( ( names[ s1 ], " " ) );
        FOR s2 FROM LWB sets TO UPB sets DO
            print( ( fixed( sets[ s1 ] JACCARD sets[ s2 ], -7, 3 ) ) )
        OD;
        print( ( newline ) )
    OD
END
