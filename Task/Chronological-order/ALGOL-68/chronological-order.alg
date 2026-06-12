BEGIN # print lines from a file in chronological order                        #
      # the lines end with a year and BCE/CE and must be output unchanged     #

    PR read "files.incl.a68" PR      # include file utilities inc. READLINES  #
    PR read "sort.incl.a68" PR       # include sort utilities inc. QUICKSORT  #

    # gets a signed year from the end of s, BCE years are negative            #
    # minimal error checking                                                  #
    OP    YEAROF = ( STRING s )INT:
          BEGIN
             INT s pos := UPB s;
             INT year  := 0, sign := 1;
             # skip trailing spaces, tabs, etc.        #
             WHILE IF s pos < LWB s THEN FALSE ELSE s[ s pos ] <= " " FI DO  s pos -:= 1 OD;
             # skip the CE/BCE handling the sign       #
             WHILE IF s pos < LWB s THEN FALSE ELSE s[ s pos ] >= "A" AND s[ s pos ] <= "E" FI DO
                 IF s[ s pos ] = "B" THEN sign := -1 FI;
                 s pos -:= 1
             OD;
             # skip spaces, tabs, etc. after the year  #
             WHILE IF s pos < LWB s THEN FALSE ELSE s[ s pos ] <= " " FI DO  s pos -:= 1 OD;
             # find the year digits                    #
             INT y end := s pos, y start := s pos;
             WHILE IF s pos < LWB s THEN FALSE ELSE s[ s pos ] >= "0" AND s[ s pos ] <= "9" FI DO
                 y start := s pos;
                 s pos  -:= 1
             OD;
             # compute the year                        #
             IF y start >= LWB s THEN
                 FOR y pos FROM y start TO y end DO
                     year *:= 10 +:= ABS s[ y pos ] - ABS "0"
                 OD
             FI;
             year * sign
          END # YEAROF # ;

    # reads and outputs the data from file name, ordered by the BCE/CE year   #
    PROC order = ( STRING file name )VOID:
         IF REF[]STRING lines = READLINES file name;
            LWB lines > UPB lines
         THEN
            print( ( file name, " is empty or couldn't be read", newline ) )
         ELSE
            # prefix each line with the year, suitably modified so the sort   #
            # order is correct                                                #
            FOR l pos FROM LWB lines TO UPB lines DO
                INT    year    = YEAROF lines[ l pos ];
                STRING prefix := whole( year, -12 );
                IF year >= 0 THEN
                    # CE year: replace spaces with "@", digits with letters   #
                    FOR y pos FROM LWB prefix TO UPB prefix DO
                        IF   prefix[ y pos ] = " " THEN
                             prefix[ y pos ] := "@"
                        ELIF prefix[ y pos ] >= "0" AND prefix[ y pos ] <= "9" THEN
                             prefix[ y pos ] := REPR ( ABS "A" + ( ABS prefix[ y pos ] - ABS "0" ) )
                        FI
                    OD
                ELSE
                    # BCE year: 9s complement the digits and replace spaces   #
                    # with "="                                                #
                    FOR y pos FROM LWB prefix TO UPB prefix DO
                        IF   prefix[ y pos ] = " " OR prefix[ y pos ] = "-" THEN
                             prefix[ y pos ] := "="
                        ELIF prefix[ y pos ] >= "0" AND prefix[ y pos ] <= "9" THEN
                             prefix[ y pos ] := REPR ( ABS "9" - ( ABS prefix[ y pos ] - ABS "0" ) )
                        FI
                    OD
                FI;
                prefix + ":" +=: lines[ l pos ]
            OD;
            QUICKSORT lines;
            # print the lines without the leading year:                       #
            FOR l pos FROM LWB lines TO UPB lines DO
                print( ( lines[ l pos ][ LWB lines[ l pos ] + 13 : ], newline ) )
            OD
         FI # order # ;

    BEGIN
        order( "table.txt"  );
        print( ( newline, newline ) );
        order( "table2.txt" );
        print( ( newline, newline ) );
        order( "table3.txt" )
    END

END
