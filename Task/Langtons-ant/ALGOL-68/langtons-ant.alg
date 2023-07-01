BEGIN
    # size of board for Langton's ant #
    INT max board = 100;
    [ 1 : max board, 1 : max board ]CHAR board;
    # start with the board all white #
    CHAR white = " ", black = "#";
    FOR r TO 1 UPB board DO FOR c TO 2 UPB board DO board[ r, c ] := white OD OD;
    # possible ant directions #
    INT head left = 0, head up = 1, head right = 2, head down = 3;
    # returns the new direction if we turn left from curr direction #
    OP LEFT = ( INT curr direction )INT:
       IF   curr direction = head left  THEN head down
       ELIF curr direction = head down  THEN head right
       ELIF curr direction = head right THEN head up
       ELSE                                  head left
       FI ; # LEFT #
    # returns the new direction if we turn right from curr direction #
    OP RIGHT = ( INT curr direction )INT:
       IF   curr direction = head left  THEN head up
       ELIF curr direction = head up    THEN head right
       ELIF curr direction = head right THEN head down
       ELSE                                  head left
       FI ; # RIGHT #
    # move the ant until it leaves the board #
    INT ant row := max board OVER 2;
    INT ant col := max board OVER 2;
    INT ant direction := head up;
    INT max row := 1;
    INT max col := 1;
    INT min row := max board;
    INT min col := max board;
    INT moves := 0;
    WHILE ant row >= 1 LWB board AND ant row <= 1 UPB board
      AND ant col >= 2 LWB board AND ant col <= 2 UPB board
    DO
        moves +:= 1;
        IF ant row > max row THEN max row := ant row FI;
        IF ant col > max col THEN max col := ant col FI;
        IF ant row < min row THEN min row := ant row FI;
        IF ant col < min col THEN min col := ant col FI;
        IF board[ ant row, ant col ] = white THEN
            # ant turns right on a white square #
            ant direction := RIGHT ant direction;
            board[ ant row, ant col ] := black
        ELSE
            # ant turns left on a black square #
            ant direction :=  LEFT ant direction;
            board[ ant row, ant col ] := white
        FI;
        # move the ant #
        IF     ant direction = head up    THEN ant row -:= 1
        ELIF   ant direction = head down  THEN ant row +:= 1
        ELIF   ant direction = head left  THEN ant col -:= 1
        ELSE # ant direction = head right #    ant col +:= 1
        FI
    OD;
    # show resultant position #
    print( ( "After ", whole( moves, 0 ), " moves."
           , " Showing rows ", whole( min row,0 ), " to ", whole( max row, 0 )
           , " columns ", whole( min col,0 ), " to ", whole( max col, 0 )
           , newline
           )
         );
    FOR r FROM min row TO max row DO
        print( ( board[ r, min col : max col ], newline ) )
    OD
END
