BEGIN # finite state machine                                                  #

    # mode representing a state in the FSM                                    #
    MODE FSMSTATE = STRUCT( INT state                    # code for the state #
                          , PROC INT next state     # routine to change state #
                          );
    # executes the FSM defined by states, starting from the initial state     #
    # and terminating when the exit state is reached                          #
    PROC run fsm = ( []FSMSTATE states, INT initial state, exit state )VOID:
         BEGIN
            INT state := initial state;
            WHILE state /= exit state DO
                BOOL found := FALSE;
                FOR s pos FROM LWB states TO UPB states WHILE NOT found DO
                    IF found := state OF states[ s pos ] = state THEN
                        state := next state OF states[ s pos ]
                    FI
                OD;
                IF NOT found THEN
                    # in an invalid state - restart                           #
                    print( ( "(resetting)", newline ) );
                    state := initial state
                FI
            OD
         END # run fsm # ;

    BEGIN # test FSM                                                          #
        # possible states                                                     #
        INT exit = 0, ready = 1, waiting = 2, dispense = 3, refunding = 4;

        # prompts the user for a single character code and returns it         #
        # the user is re-prompted until they enter one of the characters in   #
        # answers                                                             #
        PROC get code = ( STRING prompt, answers )CHAR:
             BEGIN
                 CHAR response;
                 WHILE print( ( prompt, ": " ) );
                       STRING answer;
                       read( ( answer, newline ) );
                       response := IF answer = "" THEN REPR 0 ELSE answer[ LWB answer ] FI;
                       IF response >= "a" AND response <= "z" THEN
                           # convert lowercase response to upper              #
                           response := REPR ( ABS response + ( ABS "A" - ABS "a" ) )
                       FI;
                       NOT char in string( response, NIL, answers )
                 DO SKIP OD;
                 response
             END # get code # ;

        run fsm( ( ( ready
                   , INT: IF "Q" = get code( "Ready     : Enter D to deposit, Q to Quit", "DQ" )
                          THEN exit
                          ELSE waiting
                          FI
                   )
                 , ( waiting
                   , INT: IF "S" = get code( "Waiting   : Enter S to Select, R to Refund", "SR" )
                          THEN dispense
                          ELSE refunding
                          FI
                   )
                 , ( dispense
                   , INT: BEGIN VOID( get code( "Dispensing: Remove your product and Enter R", "R" ) );
                                ready
                          END
                   )
                 , ( refunding
                   , INT: BEGIN print( ( "Refunding", newline ) ); ready END
                   )
                 )
               , ready
               , exit
               )

    END

END
