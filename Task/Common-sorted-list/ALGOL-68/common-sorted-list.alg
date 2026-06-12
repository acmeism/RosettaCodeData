BEGIN # construct a list if the sorted common elements from a other lists    #

    PR read "sort.incl.a68" PR                      # include sort utilities #
    PR read "rows.incl.a68" PR               # include row (array) utilities #

    OP   LEN = ( []INT a )INT: ( UPB a - LWB a ) + 1;   # element count of a #

    # concatenates the rows of a, returns the sorted unique common elements  #
    OP   COMMON = ( [][]INT a )[]INT:
         IF   INT total elements := 0;               # have at least one row #
              FOR i FROM LWB a TO UPB a DO total elements +:= LEN a[ i ] OD;
              total elements < 1
         THEN           # no rows or all the rows are empty - so no elements #
              [ 1 : 0 ]INT empty row;
              empty row
         ELSE                                         # at least one element #
              [ 1 : total elements ]INT joined;   # concatenate the elements #
              INT j end := 0;
              FOR a pos FROM LWB a TO UPB a DO
                  INT this len = LEN a[ a pos ];
                  IF this len > 0 THEN
                      INT next end = j end + this len;
                      joined[ j end + 1 : next end ] := a[ a pos ][ AT 1 ];
                      j end := next end
                  FI
              OD;
              joined QUICKSORT ELEMENTS( 1, j end );                  # sort #
              [ 1 : j end ]INT result;                   # remove duplicates #
              INT r pos       := 1;
              result[ r pos ] := joined[ 1 ];
              FOR j pos FROM 2 TO j end DO
                  IF result[ r pos ] /= joined[ j pos ] THEN
                      result[ r pos +:= 1 ] := joined[ j pos ]
                  FI
              OD;
              result[ 1 : r pos ]
         FI # COMMON # ;

        PROC test common = ( [][]INT a )VOID:    # tests the COMMON operator #
             BEGIN
                print( ( "Sorted common elements of: [" ) );
                FOR i FROM LWB a TO UPB a DO
                    print( ( " [" ) ); SHOW a[ i ]; print( ( " ]" ) )
                OD;
                print( ( " ]", newline, "                         : [" ) );
                SHOW COMMON a;
                print( ( " ]", newline ) )
             END # test common # ;

    test common( ( ( 5, 1, 3, 8, 9, 4, 8, 7 )
                 , ( 3, 5, 9, 8, 4 )
                 , ( 1, 3, 7, 9 )
                 )
               );
    test common( ( ()
                 , ( 7, 7, 3, 5, 9, 8, 4 )
                 , ( 1, 3, 7, 9 )
                 )
               );
    test common( () )
    # ALGOL 68 Genie version 2 doesn't like the final test common call       #
    # for ALGOL 68 Genie, replace it with the following:                     #
    # [ 1 : 0 ][ 1 : 0 ]INT empty row of row of int;                         #
    # test common( empty row of row of int )                                 #
END
