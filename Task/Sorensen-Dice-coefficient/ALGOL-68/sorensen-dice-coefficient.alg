BEGIN # use the Sorensen–Dice coefficient to find the nearest matches for     #
      # some task names in a list of tasks                                    #

    PR read "files.incl.a68" PR # include file utilities, including READLINES #
    PR read "sort.incl.a68"  PR # include sort utilities, including QUICKSORT #

    # details of a bi-graph                                                   #
    MODE BIGRAPH = STRUCT( STRING bg, INT count );

    # returns the length of s                                                 #
    OP   LENGTH = ( STRING s )INT: ( UPB s - LWB s ) + 1;

    # returns the bi-graphs from line, spaces and control-characters delimit  #
    #         words but are otherwise ignored                                 #
    OP   BIGRAPHS = ( STRING line )[]BIGRAPH:
         BEGIN
            INT c len = LENGTH line;
            OP   NORMALISE = ( INT pos )CHAR:
                 IF   pos > c len THEN " "
                 ELIF CHAR c = line[ pos ]; c <= " " THEN " "
                 ELIF c >= "a" AND c <= "z" THEN REPR ( ( ABS c - ABS "a" ) + ABS "A" )
                 ELSE c
                 FI # NORMALISE # ;
            # split into bi-graphs, handling word boundaries                  #
            # a one-character word forms a bi-graph containing the character  #
            # followed by a space, space does not appear in the bi-graphs of  #
            # longer words                                                    #
            [ 1 : c len - 1 ]STRING bg;
            BOOL in word   := line[ LWB line ] > " ";
            INT  bg len    := 0;
            CHAR this char := NORMALISE LWB line;
            FOR bg pos FROM LWB line TO UPB line DO
                CHAR next char = NORMALISE ( bg pos + 1 );
                IF this char = " " THEN
                    in word            := FALSE
                ELIF in word AND next char > " " THEN
                    bg[ bg len +:= 1 ] := this char + next char
                ELIF NOT in word THEN
                    bg[ bg len +:= 1 ] := this char + next char;
                    in word            := next char > " "
                FI;
                this char := next char
            OD;
            bg QUICKSORT ELEMENTS( 1, bg len );          # sort the bi-graphs #
            # count the occurances of each bi-graph                           #
            [ 1 : bg len ]BIGRAPH bg set;
            IF   bg len < 1
            THEN bg set                               # no bi-graphs afterall #
            ELSE INT set len := 1;
                 bg set[ 1 ] := BIGRAPH( bg[ 1 ], 1 );
                 FOR bg pos FROM LWB bg + 1 TO bg len DO
                     IF   bg[ bg pos ] = bg OF bg set[ set len ]
                     THEN count OF bg set[ set len ] +:= 1
                     ELSE bg set[ set len +:= 1 ] := ( bg[ bg pos ], 1 )
                     FI
                 OD;
                 bg set[ 1 : set len ]
            FI
         END # BIGRAPHS # ;

    # returns the Sorensen–Dice coefficient of a compared to b                #
    PRIO SDCOEFFICIENT = 1;
    OP   SDCOEFFICIENT = ( []BIGRAPH bga, bgb )REAL:
         BEGIN
            INT i len := 0, a len := 0, b len := 0;
            FOR b pos FROM LWB bgb TO UPB bgb DO b len +:= count OF bgb[ b pos ] OD;
            FOR a pos FROM LWB bga TO UPB bga DO
                BIGRAPH bg = bga[ a pos ];
                a len +:= count OF bg;
                FOR b pos FROM LWB bgb TO UPB bgb WHILE bg OF bgb[ b pos ] <= bg OF bg DO
                    IF bg OF bg = bg OF bgb[ b pos ]
                    THEN i len +:= IF   count OF bg < count OF bgb[ b pos ]
                                   THEN count OF bg
                                   ELSE count OF bgb[ b pos ]
                                   FI
                    FI
                OD
            OD;
            ( 2 * i len ) / ( a len + b len )
         END # SDCOEFFICIENT # ;

    # task                                                                    #

    IF   REF[]STRING tasks = READLINES "tasks.txt";
         UPB tasks < LWB tasks
    THEN print( ( "Unable to read tasks.txt", newline ) )
    ELSE                                                  # tasks.txt read OK #
         # find the closest matches for the specified non-task names          #
         []STRING tests = ( "Primordial primes"
                          , "Sunkist-Giuliani formula"
                          , "Sieve of Euripides"
                          , "Chowder numbers"
                          );
         MODE SDMATCH = STRUCT( REAL sd, STRING name );
         FOR t pos FROM LWB tests TO UPB tests DO
             [ 1 : 5 ]SDMATCH closest := ( ( 0, "" ), ( 0, "" ), ( 0, "" ), ( 0, "" ), ( 0, "" ) );
             INT max closest           = UPB closest;
             STRING    test = tests[ t pos ];
             []BIGRAPH tbg  = BIGRAPHS test;
             print( ( test, ":", newline ) );
             FOR d pos FROM LWB tasks TO UPB tasks DO
                 STRING     task = tasks[ d pos ];
                 IF REAL sd = tbg SDCOEFFICIENT BIGRAPHS task; sd > sd OF closest[ max closest ] THEN
                     BOOL added := FALSE;
                     FOR pos TO UPB closest - 1 WHILE NOT added DO
                         IF added := sd > sd OF closest[ pos ] THEN
                             closest[ pos + 1 : max closest ] := closest[ pos : max closest - 1 ];
                             closest[ pos                   ] := ( sd, task )
                         FI
                     OD;
                     IF NOT added THEN closest[ max closest ] := ( sd, task ) FI
                 FI
             OD;
             FOR c pos TO UPB closest DO
                 print( ( "    ", fixed( sd OF closest[ c pos ], -8, 4 ) ) );
                 print( ( ": ", name OF closest[ c pos ], newline ) )
             OD
         OD

    FI

END
