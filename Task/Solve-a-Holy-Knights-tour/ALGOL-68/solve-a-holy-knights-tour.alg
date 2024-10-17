# the vertical position changes of the moves                             #
#                 nne  ne  se sse ssw  sw  nw nnw                        #
[]INT offset v = ( -2, -1,  1,  2,  2,  1, -1, -2 );
# the horizontal position changes of the moves                           #
#                 nne  ne  se sse ssw  sw  nw nnw                        #
[]INT offset h = (  1,  2,  2,  1, -1, -2, -2, -1 );

INT lowest move  = LWB offset v;
INT highest move = UPB offset v;

MODE SQUARE = STRUCT( INT move      # the number of the move that caused #
                                    # the knight to reach this square    #
                    , INT direction # the direction of the move that     #
                                    # brought the knight here - one of   #
                                    # nne, ne, se, sse, ssw, sw, nw or   #
                                    # nnw                                #
                    );
# get the size of the board - must be between 4 and 8                    #
INT board size = 8;
# the board #
[ board size, board size ]SQUARE board;
# starting position #
INT start row := 1;
INT start col := 1;
# the tour will be complete when we have made as many moves              #
# as there are free squares in the initial board                         #
INT  final move    := 0;

# initialise the board setting the free squares from the supplied pttern #
# the pattern has the rows in revers order                               #
PROC initialise board = ( []STRING pattern )VOID:
     BEGIN
        INT pattern row := UPB board;
        FOR row FROM 1 LWB board TO 1 UPB board
        DO
            FOR col FROM 2 LWB board TO 2 UPB board
            DO
                IF pattern[ pattern row ][ col ] = "-"
                THEN
                    # can't use this square                              #
                    board[ row, col ] := ( -1, -1 )
                ELSE
                    # available square                                   #
                    board[ row, col ] := ( 0, 0 );
                    final move +:= 1;
                    IF pattern[ pattern row ][ col ] = "1"
                    THEN
                        # have the start position                        #
                        start row := row;
                        start col := col
                    FI
                FI
            OD;
            pattern row -:= 1
        OD
     END; # initialise board #
# statistics #
INT iterations := 0;
INT backtracks := 0;

# prints the board #
PROC print tour = VOID:
BEGIN
    # format "number" into at least two characters #
    PROC n2 = ( INT number )STRING:
        IF   number < 0
        THEN
            " -"
        ELIF number < 10 AND number >= 0
        THEN
            " " + whole( number, 0 )
        ELSE
            whole( number, 0 )
        FI; # n2 #
    print( ( "     a  b  c  d  e  f  g  h", newline ) );
    print( ( "   ________________________", newline ) );
    FOR row FROM 1 UPB board BY -1 TO 1 LWB board
    DO
        print( ( n2( row ) ) );
        print( ( "|" ) );

        FOR col FROM 2 LWB board TO 2 UPB board
        DO
            print( ( " " ) );
            print( ( n2( move OF board[ row, col ] ) ) )
        OD;
        print( ( newline ) )
    OD
END; # print tour #

# update the board to the first knight's tour found starting from       #
# "start row" and "start col".                                          #
# return TRUE if one was found, FALSE otherwise                         #
PROC find tour = BOOL:
BEGIN

    BOOL result       := TRUE;
    INT  move number  := 1;
    INT  row          := start row;
    INT  col          := start col;
    INT  direction    := lowest move - 1;
    # the first move is to place the knight on the starting square #
    board[ row, col ] := ( move number, lowest move - 1 );
    # attempt to find a sequence of moves that will reach each square once #
    WHILE
        move number < final move AND result
    DO
        IF direction < highest move
        THEN
            # try the next move from this position #
            direction +:= 1;
            INT new row = row + offset v[ direction ];
            INT new col = col + offset h[ direction ];
            IF  new row <= 1 UPB board
            AND new row >= 1 LWB board
            AND new col <= 2 UPB board
            AND new col >= 2 LWB board
            THEN
                # the move is legal, check the new square is unused #
                IF move OF board[ new row, new col ] = 0
                THEN
                    # can move here #
                    iterations       +:= 1;
                    row               := new row;
                    col               := new col;
                    move number      +:= 1;
                    board[ row, col ] := ( move number, direction );
                    direction         := lowest move - 1
                FI
            FI
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
                row -:= offset v[ direction OF board[ curr row, curr col ] ];
                col -:= offset h[ direction OF board[ curr row, curr col ] ];
                # determine which direction to try next #
                direction := direction OF board[ curr row, curr col ];
                # reset the square we just backtracked from #
                board[ curr row, curr col ] := ( 0, 0 )
            FI
        FI
    OD;
    result
END; # find tour #

BEGIN # calculate the tour from the start position, if possible #
    initialise board( ( "-000----"
                      , "-0-00---"
                      , "-0000000"
                      , "000--0-0"
                      , "0-0--000"
                      , "1000000-"
                      , "--00-0--"
                      , "---000--"
                      )
                    );
    IF find tour
    THEN
        # found a solution #
        print tour
    ELSE
        # couldn't find a solution #
        print( ( "Solution not found", newline ) )
    FI;
    print( ( iterations, " iterations, ", backtracks, " backtracks", newline ) )
END
