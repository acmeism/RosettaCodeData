BEGIN # determuine the type of a sentence by looking at the final punctuation  #
    CHAR exclamation = "E"; # classification codes... #
    CHAR question    = "Q";
    CHAR serious     = "S";
    CHAR neutral     = "N";
    # returns the type(s) of the sentence(s) in s - exclamation, question,     #
    #                     serious or neutral; if there are multiple sentences  #
    #                     the types are separated by |                         #
    PROC classify = ( STRING s )STRING:
         BEGIN
            STRING result := "";
            BOOL pending neutral := FALSE;
            FOR s pos FROM LWB s TO UPB s DO
                IF   pending neutral := FALSE;
                     CHAR c = s[ s pos ];
                     c = "?"
                THEN result +:= question    + "|"
                ELIF c = "!"
                THEN result +:= exclamation + "|"
                ELIF c = "."
                THEN result +:= serious     + "|"
                ELSE pending neutral := TRUE
                FI
            OD;
            IF   pending neutral
            THEN result +:= neutral + "|"
            FI;
            # if s was empty, then return an empty string, otherwise remove the final separator #
            IF result = "" THEN "" ELSE result[ LWB result : UPB result - 1 ] FI
         END # classify # ;
    # task test case #
    print( ( classify( "hi there, how are you today? I'd like to present to you the washing machine 9001. "
                     + "You have been nominated to win one of these! Just make sure you don't break it"
                     )
           , newline
           )
         )
END
