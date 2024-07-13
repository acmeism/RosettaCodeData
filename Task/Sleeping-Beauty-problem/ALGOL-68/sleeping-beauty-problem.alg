BEGIN # sleeping beauty problem - translated from the Wren sample #
    PROC sleeping beauty = ( INT reps )REAL:
         BEGIN
            INT wakings := 0, heads := 0;
            FOR i TO reps DO
                wakings +:= 1;
                IF next random < 0.5 THEN # [0..0.5) = heads, [0.5..1.0) = tails say #
                    heads +:= 1
                ELSE
                    wakings +:= 1
                FI
            OD;
            print( ( "Wakings over ", whole( reps, 0 ), " repetitions = ", whole( wakings, 0 ), newline ) );
            ( heads / wakings ) * 100
         END; # sleeping beauty #

    REAL pc = sleeping beauty( 1 000 000 );
    print( ( "Percentage probability of heads on waking = ", fixed( pc, -10, 6 ), "%", newline ) )
END
