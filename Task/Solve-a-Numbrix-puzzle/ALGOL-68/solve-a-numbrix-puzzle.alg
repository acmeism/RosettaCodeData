BEGIN # solve a Numbrix puzzle - based on the Wren Hidato solver plus this   #
      # solves puzzles with 1 as an unknown using the zkl sample's method    #
    PR read "sort.incl.a68" PR                      # include sort utilities #

    [,]INT moves = ( ( 1, 0 ), ( 0, 1 ), ( -1, 0 ), ( 0, -1 ) );

    # returns TRUE if a solution for board with the specified given values   #
    #         ( the values initially placed on the board ) can be found      #
    #         n is the value to place, r and c the starting row and column   #
    #         and next the position of the next value in given               #
    # returns FALSE if a solution cannot be found                            #
    PROC solve board with givens = ( REF[,]INT board, []INT given, INT r, c, n, next, board size )BOOL:
         IF   n > board size
         THEN TRUE
         ELIF r < 1 LWB board OR r > 1 UPB board
           OR c < 2 LWB board OR c > 2 UPB board
         THEN FALSE
         ELIF INT back = board[ r, c ];
              back /= 0 AND back /= n
         THEN FALSE
         ELIF back = 0 AND IF next > UPB given THEN FALSE ELSE given[ next ] = n FI
         THEN FALSE
         ELSE INT next2 = IF back = n THEN next + 1 ELSE next FI;
              board[ r, c ] := n;
              BOOL found := FALSE;
              FOR m pos FROM 1 LWB moves TO 1 UPB moves
              WHILE INT rm = r + moves[ m pos, 2 LWB moves ];
                    INT cm = c + moves[ m pos, 2 UPB moves ];
                    NOT ( found := solve board with givens( board, given, rm, cm, n + 1, next2, board size ) )
              DO SKIP OD;
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
            IF start r = 0 THEN    # need to pretend 1 is on the board, even #
                given1[ g pos +:= 1 ] := 1                 # though is isn't #
            FI;
            [ 1 : g pos ]INT given := given1[ 1 : g pos ];
            QUICKSORT given;
            BOOL solved := FALSE;
            IF start r /= 0 THEN                # the position of 1 is known #
                solved := solve board with givens( board, given, start r, start c, 1, 1, board size )
            ELSE        # try 1 in all empty places until we find a solution #
                FOR r pos FROM 1 LWB board TO 1 UPB board WHILE NOT solved DO
                    FOR c pos FROM 2 LWB board TO 2 UPB board WHILE NOT solved DO
                        IF board[ r pos, c pos ] = 0 THEN
                           board[ r pos, c pos ] := 1;
                           solved := solve board with givens( board, given, r pos, c pos, 1, 1, board size );
                           IF NOT solved THEN board[ r pos, c pos ] := 0 FI
                        FI
                    OD
                OD
            FI;
            IF solved THEN board ELSE [ 1 : 0, 1 : 0 ]INT no solution; no solution FI
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


    [,,]INT tests = ( ( (  0,  0,  0,  0,  0,  0,  0,  0,  0 )
                      , (  0,  0, 46, 45,  0, 55, 74,  0,  0 )
                      , (  0, 38,  0,  0, 43,  0,  0, 78,  0 )
                      , (  0, 35,  0,  0,  0,  0,  0, 71,  0 )
                      , (  0,  0, 33,  0,  0,  0, 59,  0,  0 )
                      , (  0, 17,  0,  0,  0,  0,  0, 67,  0 )
                      , (  0, 18,  0,  0, 11,  0,  0, 64,  0 )
                      , (  0,  0, 24, 21,  0,  1,  2,  0,  0 )
                      , (  0,  0,  0,  0,  0,  0,  0,  0,  0 )
                      )
                    , ( (  0,  0,  0,  0,  0,  0,  0,  0,  0 )
                      , (  0, 11, 12, 15, 18, 21, 62, 61,  0 )
                      , (  0,  6,  0,  0,  0,  0,  0, 60,  0 )
                      , (  0, 33,  0,  0,  0,  0,  0, 57,  0 )
                      , (  0, 32,  0,  0,  0,  0,  0, 56,  0 )
                      , (  0, 37,  0,  1,  0,  0,  0, 73,  0 )
                      , (  0, 38,  0,  0,  0,  0,  0, 72,  0 )
                      , (  0, 43, 44, 47, 48, 51, 76, 77,  0 )
                      , (  0,  0,  0,  0,  0,  0,  0,  0,  0 )
                      )
                    , ( ( 17,  0,  0,  0, 11,  0,  0,  0, 59 )
                      , (  0, 15,  0,  0,  6,  0,  0, 61,  0 )
                      , (  0,  0,  3,  0,  0,  0, 63,  0,  0 )
                      , (  0,  0,  0,  0, 66,  0,  0,  0,  0 )
                      , ( 23, 24,  0, 68, 67, 78,  0, 54, 55 )
                      , (  0,  0,  0,  0, 72,  0,  0,  0,  0 )
                      , (  0,  0, 35,  0,  0,  0, 49,  0,  0 )
                      , (  0, 29,  0,  0, 40,  0,  0, 47,  0 )
                      , ( 31,  0,  0,  0, 39,  0,  0,  0, 45 )
                      )
                    );
    FOR t pos FROM 1 LWB tests TO 1 UPB tests DO
        [,]INT board = tests[ t pos, : , : ];
        print board( board );
        print( ( newline ) );
        IF   [,]INT solution = solve( board );
             1 LWB solution > 1 UPB solution
        THEN print( ( "No solution found", newline ) )
        ELSE print board( solution )
        FI;
        print( ( newline ) )
    OD
END
