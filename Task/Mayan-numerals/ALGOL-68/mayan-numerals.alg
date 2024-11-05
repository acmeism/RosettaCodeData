BEGIN
    # print Mayan numerals                                                   #
    # Mayan numerals are base-20 positional numbers, each digit consists of  #
    # four four character lines in a box                                     #

    # converts n to a mayan representation                                   #
    OP TOMAYAN = ( INT n )[]STRING:
       BEGIN
           # cartouche boarders, etc.                                        #
           CHAR    top left   = REPR 201; CHAR    top middle = REPR 203; CHAR    top right  = REPR 187;
           CHAR bottom left   = REPR 200; CHAR bottom middle = REPR 202; CHAR bottom right  = REPR 188;
           CHAR vertical      = REPR 186; CHAR horizontal    = REPR 205; CHAR turtle        = "@";
           STRING   horizontal edge = horizontal + horizontal + horizontal + horizontal;
           # representations of 1, 2, 3 etc.                                 #
           []STRING fragment = ( " .  ", " .. ", "... ", "....", "----" );
           STRING blanks = "    "; STRING zero = " " + turtle + "  ";
           # build the cartouche                                             #
           INT final line = 6;
           [ 1 : final line ]STRING result;
           IF n < 0 THEN                    # negative numbers not supported #
               FOR i TO final line DO result[ i ] := "?" OD
           ELSE                                              # 0 or negative #
               FOR i TO final line DO result[ i ] := ""  OD;
               top right +=: result[ 1 ];      # right edge of the cartouche #
               FOR i FROM 2 TO final line - 1 DO vertical +=: result[ i ] OD;
               bottom right +=: result[ final line ];
               INT rest := n;                                  # number body #
               WHILE
                   INT digit := rest MOD 20; rest OVERAB 20;
                   INT f     := digit;
                   horizontal edge +=: result[ 1 ];
                   FOR i FROM final line - 1 BY -1 TO 2 DO
                       IF   f >= 5 THEN
                           fragment[ 5 ] +=: result[ i ]
                       ELIF f  = 0 THEN
                           IF i = final line - 1 THEN zero ELSE blanks FI +=: result[ i ]
                       ELSE
                           fragment[ digit MOD 5 ] +=: result[ i ]
                       FI;
                       IF f > 5 THEN f -:= 5 ELSE f := 0 FI
                   OD;
                   horizontal edge +=: result[ final line ];
                   rest > 0
               DO
                   # add a separator                                         #
                   top middle +=:result[ 1 ];
                   FOR i FROM 2 TO UPB result - 1 DO vertical +=: result[ i ] OD;
                   bottom middle +=: result[ final line ]
               OD;
               top left +=: result[ 1 ];        # left edge of the cartouche #
               FOR i FROM 2 TO final line - 1 DO vertical +=: result[ i ] OD;
               bottom left +=: result[ final line ]
           FI;
           result
       END # TOMAYAN # ;
    # print n as a mayan number                                              #
    PROC print mayan = ( INT n )VOID:
         BEGIN
             []STRING cartouche = TOMAYAN n;
             FOR i TO UPB cartouche DO print( ( cartouche[ i ], newline ) ) OD
         END # print mayan # ;

    []INT test cases = ( 4 005, 8 017, 326 205, 886 205, 68, 1303 );
    FOR n FROM LWB test cases TO UPB test cases DO
        print( ( "Mayan representation of ", whole( test cases[ n ], 0 ), newline ) );
        print mayan( test cases[ n ] )
    OD
END
