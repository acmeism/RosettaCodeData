IF  FILE input file;
    STRING file name = "printItself.a68";
    open( input file, file name, stand in channel ) /= 0
THEN
    # failed to open the file                                              #
    print( ( "Unable to open """ + file name + """", newline ) )
ELSE
    # file opened OK                                                       #
    BOOL at eof := FALSE;
    on logical file end( input file     # set the EOF handler for the file #
                       , ( REF FILE f )BOOL:
                         BEGIN
                             # note that we reached EOF on the latest read #
                             # and return TRUE so processing can continue  #
                             at eof := TRUE
                         END
                       );
    WHILE STRING line;
          get( input file, ( line, newline ) );
          NOT at eof
    DO
        print( ( line, newline ) )
    OD;
    close( input file )
FI
