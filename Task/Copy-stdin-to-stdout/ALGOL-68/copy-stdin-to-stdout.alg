BEGIN
    BOOL at eof := FALSE;
    # set the EOF handler for stand in to a procedure that sets "at eof" to true #
    # and returns true so processing can continue                                #
    on logical file end( stand in, ( REF FILE f )BOOL: at eof := TRUE );
    # copy stand in to stand out                                                 #
    WHILE STRING line; read( ( line, newline ) ); NOT at eof DO write( ( line, newline ) ) OD
END
