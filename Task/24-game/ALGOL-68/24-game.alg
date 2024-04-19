BEGIN # play the 24 game - present the user with 4 digits and invite them to  #
      # enter an expression using the digits that evaluates to 24             #

    [ 0 : 9 ]INT expression digits;          # the digits entered by the user #
    [ 0 : 9 ]INT puzzle digits;                   # the digits for the puzzle #
    PROC eval = ( STRING expr )REAL:              # parses and evaluates expr #
         BEGIN
            # syntax: expression = term ( ( "+" | "-" ) term )*               #
            #         term       = factor ( ( "*" | "/" ) factor ) *          #
            #         factor     = "0" | "1" | "2" | ... | "9"                #
            #                    | "(" expression ")"                         #
            INT  x pos := LWB expr - 1;
            INT  x end := UPB expr;
            BOOL ok    := TRUE;
            PROC error = ( STRING msg )VOID:
                 IF ok THEN                        # this is the firstt error #
                    ok := FALSE;
                    print( ( msg, newline ) );
                    x pos := x end + 1
                 FI # error # ;
            PROC curr ch = CHAR: IF x pos > x end THEN REPR 0 ELSE expr[ x pos ] FI;
            PROC next ch = VOID: WHILE x pos +:= 1; curr ch = " " DO SKIP OD;
            PROC factor = REAL:
                 IF curr ch >= "0" AND curr ch <= "9" THEN
                    INT  digit  = ABS curr ch - ABS "0";
                    REAL result = digit;
                    expression digits[ digit ] +:= 1;
                    next ch;
                    result
                 ELIF curr ch = "(" THEN
                    next ch;
                    REAL result = expression;
                    IF curr ch = ")" THEN
                        next ch
                    ELSE
                        error( """)"" expected after sub-expression" )
                    FI;
                    result
                 ELSE
                    error( "Unexpected """ + curr ch + """" );
                    0
                 FI # factor # ;
            PROC term = REAL:
                 BEGIN
                    REAL result := factor;
                    WHILE curr ch = "*" OR curr ch = "/" DO
                        CHAR op = curr ch;
                        next ch;
                        IF op = "*" THEN result *:= factor ELSE result /:= factor FI
                    OD;
                    result
                 END # term # ;
            PROC expression = REAL:
                 BEGIN
                    REAL result := term;
                    WHILE curr ch = "+" OR curr ch = "-" DO
                        CHAR op = curr ch;
                        next ch;
                        IF op = "+" THEN result +:= term ELSE result -:= term FI
                    OD;
                    result
                 END # expression # ;

            next ch;
            IF curr ch = REPR 0 THEN
                error( "Missing expression" );
                0
            ELSE
                REAL result = expression;
                IF curr ch /= REPR 0 THEN
                   error( "Unexpected text: """ + expr[ x pos : ] + """ after expression" )
                FI;
                result
            FI
         END # eval # ;

    WHILE
        FOR i FROM 0 TO 9 DO                   # initialise the digit counts #
            expression digits[ i ] := 0;
            puzzle digits[     i ] := 0
        OD;
        print( ( "Enter an expression using these digits:" ) );
        FOR i TO 4 DO                                 # pick 4 random digits #
            INT digit := 1 + ENTIER ( next random * 9 );
            IF digit > 9 THEN digit := 9 FI;
            puzzle digits[ digit ] +:= 1;
            print( ( whole( digit, - 2 ) ) )
        OD;
        print( ( " that evaluates to 24: " ) );
        # get and check the expression                                       #
        STRING expr;
        read( ( expr, newline ) );
        REAL result = eval( expr );
        BOOL same  := TRUE;
        FOR i FROM 0 TO 9 WHILE same := puzzle digits[ i ] = expression digits[ i ] DO SKIP OD;
        IF NOT same THEN
            print( ( "That expression didn't contain the puzzle digits", newline ) )
        ELIF result = 24 THEN
            print( ( "Yes! That expression evaluates to 24", newline ) )
        ELSE
            print( ( "No - that expression evaluates to ", fixed( result, -8, 4 ), newline ) )
        FI;
        print( ( newline, "Play again [y/n]? " ) );
        STRING play again;
        read( ( play again, newline ) );
        play again = "y" OR play again = "Y" OR play again = ""
    DO SKIP OD

END
