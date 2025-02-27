BEGIN # elementary cellular automaton - random number generation #
    COMMENT returns the next state from state using rule s must be at least 2 characters long
            and consist of # and - only
    COMMENT
    PROC next state = ( STRING state, INT rule )STRING:
         BEGIN
            COMMENT returns 1 or 0 depending on whether c = # or not COMMENT
            OP TOINT = ( CHAR c )INT: IF c = "#" THEN 1 ELSE 0 FI;
            # construct the state with additional extra elements to allow wrap-around #
            STRING s = state[ UPB state ] + state + state[ LWB state : LWB state + 1 ];
            COMMENT convert rule to a string of # or - depending on whether the bits of r are on or off
            COMMENT
            STRING r := "";
            INT    v := rule;
            TO 8 DO
                r +:= IF ODD v THEN "#" ELSE "-" FI;
                v OVERAB 2
            OD;
            STRING new state := "";
            FOR i FROM LWB s TO UPB s - 3 DO
                CHAR c1  = s[ i     ];
                CHAR c2  = s[ i + 1 ];
                CHAR c3  = s[ i + 2 ];
                INT pos := ( ( ( TOINT c1 * 2 ) + TOINT c2 ) * 2 ) + TOINT c3;
                new state +:= r[ pos + 1 ]
            OD;
            new state
         END # next state # ;
    # get a pseudo-random byte from by evolving the state #
    PROC get byte = ( REF STRING state, INT rule, element )INT:
         BEGIN
            BITS b := 16r0;
            TO 8 DO
                state := next state( state, rule );
                b     := b SHL 1;
                IF state[ element ] = "#" THEN b := b OR 16r1 FI
            OD;
            ABS b
         END # get byte # ;

    BEGIN # test #
        STRING rg state := "###############################################################-";
        TO 10 DO
            print( ( " ", whole( get byte( rg state, 30, 1 ), 0 ) ) )
        OD;
        print( ( newline ) )
    END
END
