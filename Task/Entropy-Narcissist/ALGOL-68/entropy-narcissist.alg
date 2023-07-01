BEGIN
    # calculate the shannon entropy of a string                                #
    PROC shannon entropy = ( STRING s )REAL:
    BEGIN
        INT string length = ( UPB s - LWB s ) + 1;
        # count the occurances of each character #
        [ 0 : max abs char ]INT char count;
        FOR char pos FROM LWB char count TO UPB char count DO
            char count[ char pos ] := 0
        OD;
        FOR char pos FROM LWB s TO UPB s DO
            char count[ ABS s[ char pos ] ] +:= 1
        OD;
        # calculate the entropy, we use log base 10 and then convert #
        # to log base 2 after calculating the sum                    #
        REAL entropy := 0;
        FOR char pos FROM LWB char count TO UPB char count DO
            IF char count[ char pos ] /= 0
            THEN
                # have a character that occurs in the string #
                REAL probability = char count[ char pos ] / string length;
                entropy -:= probability * log( probability )
            FI
        OD;
        entropy / log( 2 )
    END; # shannon entropy #

    IF  FILE input file;
        STRING file name = "entropyNarcissist.a68";
        open( input file, file name, stand in channel ) /= 0
    THEN
        # failed to open the file #
        print( ( "Unable to open """ + file name + """", newline ) )
    ELSE
        # file opened OK #
        BOOL at eof := FALSE;
        # set the EOF handler for the file #
        on logical file end( input file
                           , ( REF FILE f )BOOL:
                             BEGIN
                                 # note that we reached EOF on the latest read #
                                 at eof := TRUE;
                                 # return TRUE so processing can continue #
                                 TRUE
                             END
                           );
        # construct a string containing the whole file #
        STRING file contents := "";
        WHILE STRING line;
              get( input file, ( line, newline ) );
              NOT at eof
        DO
            file contents +:= line + REPR 12
        OD;
        close( input file );
        # show the entropy of the file cotents #
        print( ( shannon entropy( file contents ), newline ) )
    FI
END
