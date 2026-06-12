BEGIN # Snakes and ladders game #
    # create the board #
    INT max square = 100;
    [ 1 : max square ]INT board;
    FOR i TO max square DO board[ i ] := 0 OD;
    board[  4 ] := 14;
    board[  9 ] := 31;
    board[ 17 ] :=  7;
    board[ 20 ] := 38;
    board[ 28 ] := 84;
    board[ 40 ] := 59;
    board[ 51 ] := 67;
    board[ 54 ] := 34;
    board[ 62 ] := 19;
    board[ 63 ] := 81;
    board[ 64 ] := 60;
    board[ 71 ] := 91;
    board[ 87 ] := 24;
    board[ 93 ] := 73;
    board[ 95 ] := 75;
    board[ 99 ] := 78;
    # get options #
    INT players := 0;
    WHILE print( ( "How many players ( 1-10, 0 or less to quit ) ? " ) );
          read( ( players, newline ) );
          players > 10
    DO
        print( ( "Too many players" ) )
    OD;
    IF players > 0 THEN
        # the user does want to play #
        BOOL win on gt max := FALSE;
        WHILE print( ( "Allow position > ", whole( max square, 0 ), " to win [y/n] ? " ) );
              CHAR c;
              read( ( c, newline ) );
              win on gt max := c = "y";
              c /= "y" AND c /= "n"
        DO SKIP OD;
        BOOL extra roll for 6 := FALSE;
        WHILE print( ( "Roll again on a 6 [y/n] ? " ) );
              CHAR c;
              read( ( c, newline ) );
              extra roll for 6 := c = "y";
              c /= "y" AND c /= "n"
        DO SKIP OD;
        [ 1 : players ]INT position;
        FOR i TO players DO position[ i ] := 0 OD;
        # play #
        BOOL game over := FALSE;
        WHILE NOT game over DO
            # handle each players move #
            print( ( newline ) );
            FOR p TO players WHILE NOT game over DO
                WHILE
                    INT roll = ENTIER ( next random * 6 ) + 1;
                    STRING player id = "Player " + whole( p, 0 );
                    print( ( player id
                           , IF position[ p ] < 1 THEN "" ELSE " (on square " + whole( position[ p ], 0 ) + ")" FI
                           , " rolls a "
                           , whole( roll, 0 )
                           , newline
                           )
                         );
                    IF  position[ p ] + roll > max square
                    AND NOT win on gt max
                    THEN
                        # the player would be off the board #
                        print( ( "    ", player id, " cannot move", newline ) )
                    ELSE
                        # the player can move roll squares #
                        position[ p ] +:= roll;
                        IF position[ p ] > max square THEN position[ p ] := max square FI;
                        print( ( "    and moves to square ", whole( position[ p ], 0 ) ) );
                        IF board[ position[ p ] ] > position[ p ] THEN
                            # landed on a ladder #
                            position[ p ] := board[ position[ p ] ];
                            print( ( " - which is a ladder :) ", player id, " climbs to up ", whole( position[ p ], 0 ), newline ) )
                        ELIF board[ position[ p ] ] /= 0 THEN
                            # landed on a snake #
                            position[ p ] := board[ position[ p ] ];
                            print( ( " - which is a snake :( ", player id, " slides down to ", whole( position[ p ], 0 ), newline ) )
                        ELIF position[ p ] >= max square THEN
                            # the player has won #
                            print( ( " and wins the game!", newline ) );
                            game over := TRUE
                        ELSE
                            # not a ladder, snake or winning move #
                            print( ( newline ) )
                        FI
                    FI;
                    roll = 6 AND extra roll for 6 AND NOT game over
                DO
                    print( ( player id, " can roll again...", newline ) )
                OD
            OD
        OD
    FI
END
