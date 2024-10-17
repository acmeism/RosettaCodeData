BEGIN # use unixdict.txt to test the plausibility of                         #
      # "i before e except after c"                                          #

    PR read "files.incl.a68" PR                     # include file utilities #

    # implements the plausibility test specified by the task                 #
    # returns TRUE if with > 2 * without                                     #
    PROC plausible = ( INT with, without )BOOL: with > 2 * without;

    # shows the plausibility of with and without                             #
    PROC show plausibility = ( STRING legend, INT with, without )VOID:
         print( ( legend, " is ", IF plausible( with, without ) THEN "" ELSE "not " FI
                , "plausible", newline
                )
              );

    INT    cei := 0;
    INT    xei := 0;
    INT    cie := 0;
    INT    xie := 0;

    # examines word for cie, xie (x /= c), cei and xei (x /= c)              #
    PROC test i before e = ( STRING word )VOID:
         IF   word = "ie" THEN
            xie +:= 1
         ELIF word = "ei" THEN
            xei +:= 1
         ELSE
            INT length = ( UPB word - LWB word ) + 1;
            IF length > 1 THEN
                IF   word[ LWB word ] = "i" AND word[ LWB word + 1 ] = "e" THEN
                    # word starts ie                                         #
                    xie +:= 1
                ELIF word[ LWB word ] = "e" AND word[ LWB word + 1 ] = "i" THEN
                    # word starts ei                                         #
                    xei +:= 1
                FI;
                FOR pos FROM LWB word + 1 TO UPB word - 1 DO
                    IF   word[ pos ] = "i" AND word[ pos + 1 ] = "e" THEN
                        # have i before e, check the preceeding character    #
                        IF word[ pos - 1 ] = "c" THEN cie ELSE xie FI +:= 1
                    ELIF word[ pos ] = "e" AND word[ pos + 1 ] = "i" THEN
                        # have e before i, check the preceeding character    #
                        IF word[ pos - 1 ] = "c" THEN cei ELSE xei FI +:= 1
                    FI
                OD
            FI
         FI # test i before e # ;

    # test the hypothesis                                                    #

    IF "unixdict.txt" EACHLINE test i before e < 0 THEN
        print( ( "Unable to open unixdict.txt", newline ) )
    ELSE
        print( ( "cie occurances: ", whole( cie, 0 ), newline ) );
        print( ( "xie occurances: ", whole( xie, 0 ), newline ) );
        print( ( "cei occurances: ", whole( cei, 0 ), newline ) );
        print( ( "xei occurances: ", whole( xei, 0 ), newline ) );
        show plausibility( "i before e except after c", xie, cie );
        show plausibility( "e before i except after c", xei, cei );
        show plausibility( "i before e   when after c", cie, xie );
        show plausibility( "e before i   when after c", cei, xei );
        show plausibility( "i before e     in general", xie + cie, xei + cei );
        show plausibility( "e before i     in general", xei + cei, xie + cie )
    FI

END
