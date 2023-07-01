# tests the plausibility of "i before e except after c" using unixdict.txt #

# implements the plausibility test specified by the task                   #
# returns TRUE if with > 2 * without                                       #
PROC plausible = ( INT with, without )BOOL: with > 2 * without;

# shows the plausibility of with and without                               #
PROC show plausibility = ( STRING legend, INT with, without )VOID:
     print( ( legend, IF plausible( with, without ) THEN " is plausible" ELSE " is not plausible" FI, newline ) );

IF  FILE input file;
    STRING file name = "unixdict.txt";
    open( input file, file name, stand in channel ) /= 0
THEN
    # failed to open the file #
    print( (  "Unable to open """ + file name + """", newline ) )
ELSE
    # file opened OK #
    BOOL at eof := FALSE;
    # set the EOF handler for the file #
    on logical file end( input file, ( REF FILE f )BOOL:
                                     BEGIN
                                         # note that we reached EOF on the #
                                         # latest read #
                                         at eof := TRUE;
                                         # return TRUE so processing can continue #
                                         TRUE
                                     END
                       );
    INT    cei := 0;
    INT    xei := 0;
    INT    cie := 0;
    INT    xie := 0;
    WHILE STRING word;
          get( input file, ( word, newline ) );
          NOT at eof
    DO
        # examine the word for cie, xie (x /= c), cei and xei (x /= c)      #
        FOR pos FROM LWB word TO UPB word DO word[ pos ] := to lower( word[ pos ] ) OD;
        IF   word = "ie" THEN
            xie +:= 1
        ELIF word = "ei" THEN
            xei +:= 1
        ELSE
            INT length = ( UPB word - LWB word ) + 1;
            IF length > 1 THEN
                IF   word[ LWB word ] = "i" AND word[ LWB word + 1 ] = "e" THEN
                    # word starts ie                                        #
                    xie +:= 1
                ELIF word[ LWB word ] = "e" AND word[ LWB word + 1 ] = "i" THEN
                    # word starts ei                                        #
                    xei +:= 1
                FI;
                FOR pos FROM LWB word + 1 TO UPB word - 1 DO
                    IF   word[ pos ] = "i" AND word[ pos + 1 ] = "e" THEN
                        # have i before e, check the preceeding character   #
                        IF word[ pos - 1 ] = "c" THEN cie ELSE xie FI +:= 1
                    ELIF word[ pos ] = "e" AND word[ pos + 1 ] = "i" THEN
                        # have e before i, check the preceeding character   #
                        IF word[ pos - 1 ] = "c" THEN cei ELSE xei FI +:= 1
                    FI
                OD
            FI
        FI
    OD;
    # close the file #
    close( input file );

    # test the hypothesis                                                    #
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
