BEGIN # list division - split a list into n roughly equal parts               #
      # This deviates from the task by allowing the list to be split into     #
      # more parts than it has elements                                       #

    # lists will be represented by arrays                                     #
    # the following will implement list division for []INT, similar operators #
    # could be defined for other row modes                                    #

    PR read "rows.incl.a68" PR      # include the RC row utilities, inc. SHOW #

    # list division error handler - assign a different procedure if required  #
    PROC(STRING)VOID list division error := ( STRING msg )VOID: print( ( "**** ", msg, newline ) );

    # returns a row of rows each containing approximately 1/nth of list       #
    OP   / = ( []INT list, INT n )[]REF[]INT:
         IF n <= 0 THEN
             list division error( "Cannot divide a list by " + whole( n, 0 ) );
             [ 1 : 0 ]REF[]INT result;
             result
         ELIF n = 1 THEN
             [ 1 : 1 ]REF[]INT result;
             result[ 1 ] := HEAP[ 1 : ( UPB list - LWB list ) + 1 ]INT := list[ AT 1 ]
         ELSE
             INT elements = ( UPB list - LWB list ) + 1;
             INT part len = elements OVER n;
             INT extras   = elements MOD n; # number of components of the     #
                                            # result that will have an extra  #
                                            # element                         #
             [ 1 : n ]REF[]INT result;
             INT pos := LWB list;
             FOR i TO n DO
                 INT part size = part len + IF i <= extras THEN 1 ELSE 0 FI;
                 INT end pos   = pos + part size - 1;
                 result[ i ]  := HEAP[ 1 : part size ]INT := list[ pos : end pos ];
                 pos         +:= part size
             OD;
             result
         FI # / # ;

    # test the list division operator                                         #
    PROC test division = ( []INT list, INT n )VOID:
         BEGIN
             []REF[]INT result = list / n;
             print( ( "[" ) );
             SHOW list;
             print( ( " ] / ", whole( n, 0 ), " -> [ " ) );
             FOR i FROM LWB result TO UPB result DO
                 print( ( "[" ) );
                 SHOW result[ i ];
                 print( ( " ] " ) )
             OD;
             print( ( "]", newline ) )
         END # test division # ;

    # test cases as in the Julia sample                                       #
    test division( ( 94, 94, 13, 77, 35, 10, 51, 27, 60 ),     6 );
    test division( ( 19, 46, 43, 17, 94 ),                     1 );
    test division( ( 93, 88, 40, 88, 30, 68, 84, 25 ),         3 );
    test division( ( 88, 94, 10, 27, 54, 14 ),                 3 );
    test division( ( 31, 19, 63, 57, 57, 74, 50, 14, 38 ),     4 );
    test division( ( 72, 57, 89, 55, 36, 84, 10, 95, 99, 35 ), 7 );
    # additional test cases from the Wren sample                              #
    test division( ( 23, 49, 57 ),                            10 );
    test division( ( 1 ),                                      2 );
    test division( ( ),                                        2 );
    # additional test case                                                    #
    test division( ( 1701, 1482, 1968, 1969 ),                -2 )

END
