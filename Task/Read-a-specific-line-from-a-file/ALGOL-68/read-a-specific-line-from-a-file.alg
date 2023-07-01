# reads the line with number "number" (counting from 1)       #
# from the file named "file name" and returns the text of the #
# in "line". If an error occurs, the result is FALSE and a    #
# message is returned in "err". If no error occurs, TRUE is   #
# returned                                                    #
PROC read specific line = ( STRING     file name
                          , INT        number        # line 7 #
                          , REF STRING line
                          , REF STRING err
                          )BOOL:
     IF FILE    input file;
        line := "";
        open( input file, file name, stand in channel ) /= 0
     THEN
        # failed to open the file #
        err := "Unable to open """ + file name + """";
        FALSE
     ELSE
        # file opened OK #
        err         := "";
        BOOL at eof := FALSE;
        # set the EOF handler for the file #
        on logical file end( input file
                           , ( REF FILE f )BOOL:
                             BEGIN
                                 # note that we reached EOF on the #
                                 # latest read #
                                 at eof := TRUE;

                                 # return TRUE so processing can continue #
                                 TRUE
                             END
                           );
         INT    line number := 0;
         STRING text;
         WHILE line number < number
           AND NOT at eof
         DO
             get( input file, ( text, newline ) );
             line number +:= 1
         OD;
         # close the file #
         close( input file );
         # return the line or an error message depending on whether #
         # we got a line with the required number or not            #
         IF line number = number
         THEN
             # got the required line #
             line := text;
             TRUE
         ELSE
             # not enough lines in the file #
             err  := """" + file name + """ is too short";
             FALSE
         FI
     FI; # read specific line #
main:(
    # read the seventh line of this source and print it #
    # (or an error message if we can't)                 #
    STRING line;
    STRING err;
    IF read specific line( "read-specific-line.a68", 7, line, err )
    THEN
        # got the line #
        print( ( "line seven is: """ + line + """", newline ) )
    ELSE
        # got an error #
        print( ( "unable to read line: """ + err + """" ) )
    FI
)
