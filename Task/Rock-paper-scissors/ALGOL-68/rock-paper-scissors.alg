BEGIN
    # rock/paper/scissors game                                             #
    # counts of the number of times the player has chosen each move        #
    # we initialise each to 1 so that the total isn't zero when we are     #
    # choosing the computer's first move (as in the Ada version)           #
    INT    r count := 1;
    INT    p count := 1;
    INT    s count := 1;
    # counts of how many games the player and computer have won            #
    INT    player count   := 0;
    INT    computer count := 0;
    print( ( "rock/paper/scissors", newline, newline ) );
    WHILE
        CHAR player move;
        # get the players move - r => rock, p => paper, s => scissors      #
        #                        q => quit                                 #
        WHILE
            print( ( "Please enter your move (r/p/s) or q to quit: " ) );
            read( ( player move, newline ) );
            (   player move /= "r"
            AND player move /= "p"
            AND player move /= "s"
            AND player move /= "q"
            )
        DO
            print( ( "Unrecognised move", newline ) )
        OD;
        # continue playing until the player chooses quit                   #
        player move /= "q"
    DO
        # decide the computer's move based on the player's history         #
        CHAR  computer move;
        INT   move count     = r count + p count + s count;
        # predict player will play rock  if the random number              #
        #     is in the range 0 .. rock / total                            #
        # predict player will play paper if the random number              #
        #     is in the range rock / total .. ( rock + paper ) / total     #
        # predict player will play scissors otherwise                      #
        REAL  r limit        = r count / move count;
        REAL  p limit        = r limit + ( p count / move count );
        REAL  random move    = next random;
        IF    random move < r limit THEN
            # we predict the player will choose rock - we choose paper     #
            computer move := "p"
        ELIF  random move < p limit THEN
            # we predict the player will choose paper - we choose scissors #
            computer move := "s"
        ELSE
            # we predict the player will choose scissors - we choose rock  #
            computer move := "r"
        FI;
        print( ( "You chose: " + player   move, newline ) );
        print( ( "I   chose: " + computer move, newline ) );
        IF   player move = computer move THEN
            # both players chose the same - draw                           #
            print( ( "We draw", newline ) )
        ELSE
            # players chose different moves - there is a winner            #
            IF ( player move = "r" AND computer move = "s" )
            OR ( player move = "p" AND computer move = "r" )
            OR ( player move = "s" AND computer move = "p" )
            THEN
                player count +:= 1;
                print( ( "You win", newline ) )
            ELSE
                computer count +:= 1;
                print( ( "I win",   newline ) )
            FI;
            print( ( "You won: "
                   , whole( player count  , 0 )
                   , ", I won: "
                   , whole( computer count, 0 )
                   , newline
                   )
                 )
        FI;
        IF   player move = "r" THEN
            # player chose rock                                            #
            r count +:= 1
        ELIF player move = "p" THEN
            # player chose paper                                           #
            p count +:= 1
        ELSE
            # player chose scissors                                        #
            s count +:= 1
        FI
    OD;
    print( ( "Thanks for a most enjoyable game", newline ) )
END
