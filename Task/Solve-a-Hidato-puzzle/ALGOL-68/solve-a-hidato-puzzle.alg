BEGIN # solve a Hikado puzzle - algorithm based on the Wren solution         #
    PR read "sort.incl.a68" PR                      # include sort utilities #

    INT x = -1;                                 # non existent board element #
    INT o =  0;                                   # unoccupied board element #

    # returns TRUE if a solution for board with the specified given values   #
    #         ( the values initially placed on the board ) can be found      #
    #         n is the value to place, r and c the starting row and column   #
    #         and next the position of the next value in given               #
    # returns FALSE if a solution cannot be found                            #
    PROC solve board with givens = ( REF[,]INT board, []INT given, INT r, c, n, next )BOOL:
         IF   n > given[ UPB given ]
         THEN TRUE
         ELIF r < 1 LWB board OR r > 1 UPB board
           OR c < 2 LWB board OR c > 2 UPB board
         THEN FALSE
         ELIF INT back = board[ r, c ];
              back /= 0 AND back /= n
         THEN FALSE
         ELIF back = 0 AND given[ next ] = n
         THEN FALSE
         ELSE INT next2 = IF back = n THEN next + 1 ELSE next FI;
              board[ r, c ] := n;
              BOOL found := FALSE;
              FOR ri FROM r - 1 TO r + 1 WHILE NOT found DO
                  FOR cj FROM c - 1 TO c + 1
                  WHILE NOT ( found := solve board with givens( board, given, ri, cj, n + 1, next2 ) )
                  DO SKIP OD
              OD;
              IF NOT found THEN board[ r, c ] := back FI;
              found
         FI # solve board with givens # ;

    # returns the solution for board data                                    #
    #      or an empty board if there isn't one                              #
    PROC solve = ( [,]INT board data )[,]INT:
         BEGIN
            [ 1 LWB board data : 1 UPB board data
            , 2 LWB board data : 2 UPB board data
            ]INT board := board data;
            INT board size = ( ( 1 UPB board - 1 LWB board ) + 1 )
                           * ( ( 2 UPB board - 2 LWB board ) + 1 )
                           ;
            [ 1 : board size ]INT given1;
            INT g pos := 0, start r := 0, start c := 0;
            FOR i FROM 1 LWB board TO 1 UPB board DO
                FOR j FROM 2 LWB board TO 2 UPB board DO
                    IF board[ i, j ] > 0 THEN
                        given1[ g pos +:= 1 ] := board[ i, j ];
                        IF board[ i, j ] = 1 THEN start r := i; start c := j FI
                    FI
                OD
            OD;
            [ 1 : g pos ]INT given := given1[ 1 : g pos ];
            QUICKSORT given;
            IF   solve board with givens( board, given, start r, start c, 1, 1 )
            THEN board
            ELSE [ 1 : 0, 1 : 0 ]INT no solution; no solution
            FI
         END # solve # ;

    PROC print board = ( [,]INT board )VOID:
         FOR i FROM 1 LWB board TO 1 UPB board DO
            FOR j FROM 2 LWB board TO 2 UPB board DO
                INT v = board[ i, j ];
                IF   v < 0 THEN print( ( "   " ) )
                ELIF v = 0 THEN print( ( " __" ) )
                ELSE            print( ( whole( v, -3 ) ) )
                FI
            OD;
            print( ( newline ) )
         OD # print board # ;

    [,]INT test board = ( (  o, 33, 35,  o,  o,  x,  x,  x )
                        , (  o,  o, 24, 22,  o,  x,  x,  x )
                        , (  o,  o,  o, 21,  o,  o,  x,  x )
                        , (  o, 26,  o, 13, 40, 11,  x,  x )
                        , ( 27,  o,  o,  o,  9,  o,  1,  x )
                        , (  x,  x,  o,  o, 18,  o,  o,  x )
                        , (  x,  x,  x,  x,  o,  7,  o,  o )
                        , (  x,  x,  x,  x,  x,  x,  5,  o )
                        );
    print board( test board );
    print( ( newline ) );
    IF   [,]INT solution = solve( test board );
         1 LWB solution > 1 UPB solution
    THEN print( ( "No solution found", newline ) )
    ELSE print board( solution )
    FI

END
