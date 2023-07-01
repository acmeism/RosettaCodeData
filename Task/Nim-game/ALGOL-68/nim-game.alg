BEGIN # play Nim #
    # gets a single character answer from standin and returns it #
    PROC answer = ( STRING prompt )CHAR:
         BEGIN
             STRING s;
             INT left := 0;
             WHILE print( ( prompt, "> " ) );
                   read( ( s, newline ) );
                   left      := LWB s;
                   INT right := UPB s;
                   WHILE IF left  > right THEN FALSE ELSE s[ left  ] = " " FI DO left  +:= 1 OD;
                   WHILE IF right < left  THEN FALSE ELSE s[ right ] = " " FI DO right -:= 1 OD;
                   left /= right
             DO
                 print( ( "Please reply with a single character", newline ) )
             OD;
             s[ left ]
         END # answer # ;
    # play one game #
    INT    tokens := 12;
    STRING suffix := "";
    WHILE
        CHAR  user;
        WHILE user := answer( "There are "
                            + whole( tokens, 0 )
                            + " tokens"
                            + suffix
                            + ", how many do you want to take (1, 2 or 3)"
                            );
              user /= "1" AND user /= "2" AND user /= "3"
        DO
            print( ( "please answer 1, 2 or 3", newline ) )
        OD;
        INT move = ABS user - ABS "0";
        print( ( "I take ", whole( 4 - move, 0 ), newline ) );
        suffix  := " left";
        tokens -:= 4;
        tokens > 0
    DO SKIP OD;
    print( ( "I win!", newline ) )
END
