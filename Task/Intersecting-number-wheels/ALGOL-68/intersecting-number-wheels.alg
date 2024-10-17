BEGIN
    # a number wheel element                                                  #
    MODE NWELEMENT = UNION( CHAR # wheel name #, INT # wheel value # );
    # a number wheel                                                          #
    MODE NW = STRUCT( CHAR name, REF INT position, FLEX[ 1 : 0 ]NWELEMENT values );
    # get the next value from a number wheel in an array of number wheels     #
    # note: invalid wheel names will cause subscript range errors             #
    OP   NEXT = ( []NW wheels )INT:
         BEGIN
            INT  result;
            BOOL found := FALSE;
            INT  w     := LWB wheels; # start with the first wheel            #
            WHILE NOT found DO
                IF position OF wheels[ w ] > UPB values OF wheels[ w ] THEN
                    # passed the end of the wheel, go back to the start       #
                    position OF wheels[ w ] := LWB values OF wheels[ w ]
                FI;
                NWELEMENT e = ( values OF wheels[ w ] )[ position OF wheels[ w ] ];
                position OF wheels[ w ] +:= 1;
                CASE e
                  IN ( INT  n ): BEGIN result := n; found := TRUE END
                   , ( CHAR c ): BEGIN
                                     w := LWB wheels;
                                     WHILE name OF wheels[ w ] /= c DO w +:= 1 OD
                                 END
                ESAC
            OD;
            result
         END # NEXT # ;
    # prints the first n values from an array of wheels                       #
    PROC show = ( INT n, []NW wheels )VOID:
         BEGIN
            print( ( "First ", whole( n, 0 ), " values from the Intersecting Number Wheels:" ) );
            FOR i FROM LWB wheels TO UPB wheels DO
                print( ( newline, "    ", name OF wheels[ i ], ":" ) );
                FOR v FROM LWB values OF wheels[ i ] TO UPB values OF wheels[ i ] DO
                    CASE ( values OF wheels[ i ] )[ v ]
                      IN ( INT  n ): print( ( " ", whole( n, 0 ) ) )
                       , ( CHAR c ): print( ( " ", c ) )
                    ESAC
                OD
            OD;
            print( ( newline, "        " ) );
            TO n DO print( ( " ", whole( NEXT wheels, 0 ) ) ) OD;
            print( ( newline, newline ) )
         END # show # ;
    # show some wheels in action                                              #
    show( 20, ( NW( "A", LOC INT := 1, (  1,   2,   3  ) ) ) );
    show( 20, ( NW( "A", LOC INT := 1, (  1,  "B",  2  ) )
              , NW( "B", LOC INT := 1, (  3,   4       ) ) ) );
    show( 20, ( NW( "A", LOC INT := 1, (  1,  "D", "D" ) )
              , NW( "D", LOC INT := 1, (  6,   7,   8  ) ) ) );
    show( 20, ( NW( "A", LOC INT := 1, (  1,  "B", "C" ) )
              , NW( "B", LOC INT := 1, (  3,   4       ) )
              , NW( "C", LOC INT := 1, (  5,  "B"      ) ) ) )
END
