# Non-recursive Knight's Tour with Warnsdorff's algorithm                #
# If there are multiple choices, backtrack if the first choice doesn't   #
# find a solution                                                        #

# the size of the board                                                  #
INT board size = 8;
# the vertical position changes of the moves                             #
#                  nne, nee, see, sse, ssw, sww, nww, nnw                #
[]INT offset v = (  -2,  -1,   1,   2,   2,   1,  -1,  -2 );
# the horizontal position changes of the moves                           #
#                  nne, nee, see, sse, ssw, sww, nww, nnw                #
[]INT offset h = (   1,   2,   2,   1,  -1,  -2,  -2,  -1 );

INT lowest move  = LWB offset v;
INT highest move = UPB offset v;

MODE SQUARE = STRUCT( INT move      # the number of the move that caused #
                                    # the knight to reach this square    #
                    , INT direction # the direction of the move that     #
                                    # brought the knight here - one of   #
                                    # nne, nee, see, sse, ssw, sww, nww  #
                                    # or nnw - used for backtracking     #
                                    # zero for the first move            #
                    );

# the board #
[ board size, board size ]SQUARE board;

# initialises the board so there are no used squares #
PROC initialise board = VOID:
    FOR row FROM 1 LWB board TO 1 UPB board
    DO
        FOR col FROM 2 LWB board TO 2 UPB board
        DO
            board[ row, col ] := ( 0, 0 )
        OD
    OD; # initialise board #

INT iterations := 0;
INT backtracks := 0;

# prints the board #
PROC print tour = VOID:
BEGIN
    print( ( "       a   b   c   d   e   f   g   h", newline ) );
    print( ( "   +--------------------------------", newline ) );
    FOR row FROM 1 UPB board BY -1 TO 1 LWB board
    DO
        print( ( whole( row, -3 ) ) );
        print( ( "|" ) );
        FOR col FROM 2 LWB board TO 2 UPB board
        DO
            print( ( " " ) );
            print( ( whole( move OF board[ row, col ], -3 ) ) )
        OD;
        print( ( newline ) )
    OD
END; # print tour #

# determines whether a move to the specified row and column is possible #
PROC can move to = ( INT row, INT col )BOOL:
    IF row > 1 UPB board
    OR row < 1 LWB board
    OR col > 2 UPB board
    OR col < 2 LWB board
    THEN
        # the position is not on the board                              #
        FALSE
    ELSE
        # the move is legal, check the square is unoccupied             #
        move OF board[ row, col ] = 0
    FI;

# used to hold counts of the number of moves that could be made in each #
# direction from the current square                                     #
[ lowest move : highest move ]INT possible move count;

# sets the elements of possible move count to the number of moves that  #
# could be made in each direction from the specified row and col        #
PROC count moves in each direction from = ( INT row, INT col )VOID:
    FOR move direction FROM lowest move TO highest move
    DO
        INT new row = row + offset v[ move direction ];
        INT new col = col + offset h[ move direction ];
        IF NOT can move to( new row, new col )
        THEN
            # can't move to this square #
            possible move count[ move direction ] := -1
        ELSE
            # a move in this direction is possible #
            # - count the number of moves that could be made from it #
            possible move count[ move direction ] := 0;
            FOR subsequent move FROM lowest move TO highest move
            DO
                IF can move to( new row + offset v[ subsequent move ]
                              , new col + offset h[ subsequent move ]
                              )
                THEN
                    # have a possible subsequent move #
                    possible move count[ move direction ] +:= 1
                FI
            OD
        FI
    OD;

# update the board to the first knight's tour found starting from       #
# "start row" and "start col".                                          #
# return TRUE if one was found, FALSE otherwise                         #
PROC find tour = ( INT start row, INT start col )BOOL:
BEGIN
    initialise board;
    BOOL result := TRUE;
    INT  move number  := 1;
    INT  row          := start row;
    INT  col          := start col;
    # the tour will be complete when we have made as many moves            #
    # as there squares on the board                                        #
    INT  final move    = ( ( ( 1 UPB board ) + 1 ) - 1 LWB board )
                       * ( ( ( 2 UPB board ) + 1 ) - 2 LWB board )
                       ;
    # the first move is to place the knight on the starting square         #
    board[ row, col ]  := ( move number, lowest move - 1 );
    # start off with an unknown direction for the best move                #
    INT best direction := lowest move - 1;
    # attempt to find a sequence of moves that will reach each square once #
    WHILE
        move number < final move AND result
    DO
        iterations +:= 1;
        # count the number of moves possible from each possible move       #
        # from this square                                                 #
        count moves in each direction from( row, col );
        # find the direction with the lowest number of subsequent moves    #
        IF best direction < lowest move
        THEN
            # must find the best direction to move in                      #
            INT lowest move count := highest move + 1;
            FOR move direction FROM lowest move TO highest move
            DO
                IF  possible move count[ move direction ] >= 0
                AND possible move count[ move direction ] <  lowest move count
                THEN
                    # have a move with fewer possible subsequent moves     #
                    best direction    := move direction;
                    lowest move count := possible move count[ move direction ]
                FI
            OD
        ELSE
            # following a backtrack - find an alternative with the same    #
            # lowest number of possible moves - if there are any           #
            # if there aren't, we will backtrack again                     #
            INT lowest move count := possible move count[ best direction ];
            WHILE
                best direction +:= 1;
                IF best direction > highest move
                THEN
                    # no more possible moves with the lowest number of     #
                    # subsequent moves                                     #
                    FALSE
                ELSE
                    # keep looking if the number of moves from this square #
                    # isn't the lowest                                     #
                    possible move count[ best direction ] /= lowest move count
                FI
            DO
                SKIP
            OD
        FI;
        IF best direction  <= highest move
        AND best direction >= lowest move
        THEN
            # we found a best possible move #
            INT new row = row + offset v[ best direction ];
            INT new col = col + offset h[ best direction ];
            row               := new row;
            col               := new col;
            move number      +:= 1;
            board[ row, col ] := ( move number, best direction );
            best direction    := lowest move - 1
        ELSE
            # no more moves from this position - backtrack #
            IF move number = 1
            THEN
                # at the starting position - no solution #
                result := FALSE
            ELSE
                # not at the starting position - undo the latest move #
                backtracks  +:= 1;
                move number -:= 1;
                INT curr row := row;
                INT curr col := col;
                best direction := direction OF board[ curr row, curr col ];
                row -:= offset v[ best direction ];
                col -:= offset h[ best direction ];
                # reset the square we just backtracked from #
                board[ curr row, curr col ] := ( 0, 0 )
            FI
        FI
    OD;
    result
END; # find tour #

BEGIN
    # get the starting position #
    CHAR  row;
    CHAR  col;
    WHILE
        print( ( "Enter starting row(1-8) and col(a-h): " ) );
        read ( ( row, col, newline ) );
        row < "1" OR row > "8" OR col < "a" OR col > "h"
    DO
        SKIP
    OD;
    # calculate the tour from that position, if possible #
    IF find tour( ABS row - ABS "0", ( ABS col - ABS "a" ) + 1 )
    THEN
        # found a solution #
        print tour
    ELSE
        # couldn't find a solution #
        print( ( "Solution not found - iterations: ", iterations
               , ", backtracks: ", backtracks
               , newline
               )
             )
    FI
END
