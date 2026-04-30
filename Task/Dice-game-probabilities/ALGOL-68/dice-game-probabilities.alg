BEGIN # Dice game probabilities - translation of Action! #

    PROC roll = ( INT sides, ndice )INT:
         BEGIN
            INT sum := 0;
            FOR i TO ndice DO
                sum +:= ENTIER ( random * sides ) + 1
            OD;
            sum
         END # roll # ;

    PROC test = ( INT sides1, ndice1, sides2, ndice2 )VOID:
         BEGIN
            INT wins1 := 0, wins2 := 0, draws := 0;
            INT count  = 10 000;

            TO count DO
                INT sum1 = roll( sides1, ndice1 );
                INT sum2 = roll( sides2, ndice2 );
                IF   sum1 > sum2 THEN
                    wins1 +:= 1
                ELIF sum1 < sum2 THEN
                    wins2 +:= 1
                ELSE
                    draws +:= 1
                FI
            OD;

            print( ( "After ",           whole( count, 0 ),  " rolls", newline ) );
            print( ( "Player 1 with ",   whole( ndice1, 0 ) ) );
            print( ( " dice of ",        whole( sides1, 0 ), " sides", newline ) );
            print( ( "Player 2 with ",   whole( ndice2, 0 ) ) );
            print( ( " dice of ",        whole( sides2, 0 ), " sides", newline ) );
            print( ( "  Player 1 wins ", whole( wins1, 0 ),  " times", newline ) );
            print( ( "  Player 2 wins ", whole( wins2, 0 ),  " times", newline ) );
            print( ( "      they draw ", whole( draws, 0 ),  " times", newline ) );
            print( ( "Probability of Player 1 beating Player 2:" ) );
            print( ( fixed( wins2 / wins1, -7, 4 ), newline, newline ) )
         END # test # ;

    test(  4, 9, 6, 6 );
    test( 10, 5, 7, 6 )
END
