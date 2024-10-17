# removes the specified number of lines from a file, starting at start line (numbered fromm 1) #
# returns TRUE if successful, FALSE otherwise #
PROC remove lines = ( STRING file name, INT start line, INT number of lines )BOOL:
     IF   number of lines < 0 OR start line < 1
     THEN
        # invalid parameters #
        print( ( "number of lines must be >= 0 and start line must be >= 1", newline ) );
        FALSE
     ELIF FILE temp file;
          create( temp file, stand back channel ) /= 0
     THEN
        # unable to create a temporary output file #
        print( (  "Unable to create temporary file", newline ) );
        FALSE
     ELIF NOT reset possible( temp file )
     THEN
        # rewinding the temporary file is not possible #
        # we would have to get its name ( with "idf( temp file )", close it and re-open it #
        print( ( "Temp file is not rewindable", newline ) );
        FALSE
     ELIF FILE input file;
          open( input file, file name, stand in channel ) /= 0
     THEN
        # failed to open the file #
        print( (  "Unable to open """ + file name + """", newline ) );
        FALSE
     ELSE
        # files opened OK #
        BOOL at eof := FALSE;
        # set the EOF handler for the original file    #
        # notes that we reached EOF on the latest read #
        # and returns TRUE so processing can continue  #
        on logical file end( input file, ( REF FILE f )BOOL: at eof := TRUE );
        # copy the input file to the temp file #
        WHILE STRING line;
              get( input file, ( line, newline ) );
              NOT at eof
        DO
            put( temp file,    ( line, newline ) )
        OD;
        # copy the temp file back to the input, removing the specified lines #
        close( input file );
        IF   open( input file, file name, stand out channel ) /= 0
        THEN
            # failed to open the original file for output #
            print( ( "Unable to open ", file name, " for output", newline ) );
            FALSE
        ELSE
            # opened OK - copy the temporary file #
            reset( temp file ); # rewinds the input file #
            at eof := FALSE;
            on logical file end( temp file, ( REF FILE f )BOOL: at eof := TRUE );
            INT end line = ( start line - 1 ) + number of lines;
            INT line number := 0;
            WHILE STRING line;
                  get( temp file, ( line, newline ) );
                  NOT at eof
            DO
                # have another line #
                line number +:= 1;
                IF line number < start line OR line number > end line
                THEN
                    put( input file, ( line, newline ) )
                FI
            OD;
            # close the files #
            close(   input file );
            scratch( temp file  );
            IF   line number < start line
            THEN
                # didn't find the start line #
                print( ( "Specified start line (", whole( start line, 0 ) ) );
                print( ( ") not in ", file name, newline ) );
                FALSE
            ELIF line number < end line
            THEN
                # the ending line was not in the file #
                print( ( "Final omitted line not in the file ", file name, newline ) );
                FALSE
            ELSE
                # successful operation #
                TRUE
            FI
        FI
     FI # remove lines # ;

# test the line removal #
IF   FILE t;
     open( t, "test.txt", stand out channel ) /= 0
THEN print( ( "Unable to open test.txt for output", newline ) )
ELSE print( ( "Before...", newline ) );
     FOR i TO 10 DO
         STRING line = whole( i, - ( ( i MOD 5 ) + 3 ) );
         put( t, ( line, newline ) );
         print(  ( line, newline ) )
     OD;
     close( t );
     IF   NOT remove lines( "test.txt", 2, 3 )
     THEN print( ( "Unable to remove lines", newline ) )
     ELIF open( t, "test.txt", stand in channel ) /= 0
     THEN print( ( "Unable to open modified test.txt for input", newline ) )
     ELSE print( ( "After...", newline ) );
          TO 7 DO
              STRING line;
              get( t, ( line, newline ) );
              print(  ( line, newline ) )
          OD;
          close( t );
          print( ( "----", newline ) )
     FI
FI
