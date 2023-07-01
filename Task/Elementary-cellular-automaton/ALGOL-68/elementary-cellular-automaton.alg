BEGIN # elementary cellular automaton #
    COMMENT returns the next state from state using rule; s must be at least 2 characters long and consist of # and - only COMMENT
    PROC next state = ( STRING state, INT rule )STRING:
         BEGIN
            COMMENT returns 1 or 0 depending on whether c = # or not COMMENT
            OP TOINT = ( CHAR c )INT: IF c = "#" THEN 1 ELSE 0 FI;
            # construct the state with additional extra elements to allow wrap-around #
            STRING s = state[ UPB state ] + state + state[ LWB state : LWB state + 1 ];
            COMMENT convert rule to a string of # or - depending on whether the bits of r are on or off COMMENT
            STRING r := "";
            INT    v := rule;
            FOR i TO 8 DO
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
    # evolve state until the next state = the current state or 10 iterations have occured #
    PROC test = ( STRING state, INT rule )VOID:
         BEGIN
             print( ( "Rule ", whole( rule, 0 ), newline ) );
             STRING curr := state;
             print( ( " 0: ", curr, newline ) );
             FOR i TO 10 WHILE STRING next = next state( curr, rule );
                               next /= curr
             DO
                 print( ( whole( i, -2 ), ": ", next, newline ) );
                 curr := next
             OD
         END # test # ;
    # tests #
    test( "---------#---------", 30 );
    test( "---------#---------", 60 );
    test( "---------#---------", 90 )
END
