BEGIN # read FASTA format data from standard input and write the results to  #
      # standard output - only the ">" line start is handled                 #

    BOOL at eof := FALSE;
    on logical file end( stand in, ( REF FILE f )BOOL: at eof := TRUE );

    WHILE STRING line;
          read( ( line, newline ) );
          NOT at eof
    DO
        IF line /= "" THEN                                  # non-empty line #
            INT  start     := LWB line;
            BOOL is heading = line[ start ] = ">";  # check for heading line #
            IF is heading THEN
                print( ( newline ) );
                start +:= 1
            FI;
            print( ( line[ start : ] ) );
            IF is heading THEN print( ( ": " ) ) FI
        FI
    OD
END
