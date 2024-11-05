IF  FILE input file;
    STRING file name = "data.txt";
    open( input file, file name, stand in channel ) /= 0
THEN
    # failed to open the file #
    print( ( "Unable to open """ + file name + """", newline ) )
ELSE
    # file opened OK #
    BOOL at eof := FALSE;
    # set the EOF handler for the file #
    on logical file end( input file, ( REF FILE f )BOOL:
                                     BEGIN
                                         # note that we reached EOF on the latest read #
                                         at eof := TRUE;
                                         # return TRUE so processing can continue #
                                         TRUE
                                     END
                       );
    # return the real value of the specified field on the line #
    PROC real field = ( STRING line, INT field )REAL:
         BEGIN
            REAL result  := 0;
            INT  c pos   := LWB line;
            INT  max pos := UPB line;
            STRING f     := "";
            FOR f ield number TO field WHILE c pos <= max pos DO
                # skip leading spaces #
                WHILE IF c pos > max pos THEN FALSE ELSE line[ c pos ] = " " FI DO
                    c pos +:= 1
                OD;
                IF c pos <= max pos THEN
                    # have a field #
                    INT start pos = c pos;
                    WHILE IF c pos > max pos THEN FALSE ELSE line[ c pos ] /= " " FI DO
                        c pos +:= 1
                    OD;
                    IF field number = field THEN
                        # have the required field #
                        f := line[ start pos : c pos - 1 ]
                    FI
                FI
            OD;
            IF f /= "" THEN
                # have the field - assume it a real value and convert it #
                FILE real value;
                associate( real value, f );
                on value error( real value
                              , ( REF FILE ef )BOOL:
                                     BEGIN
                                         # "handle" invalid data #
                                         result := 0;
                                         # return TRUE so processing can continue #
                                         TRUE
                                     END
                              );
                get( real value, ( result ) )
            FI;
            result
         END # real field # ;
    # show the lines where the third field is > 6 #
    WHILE NOT at eof
    DO
        STRING line;
        get( input file, ( line, newline ) );
        IF real field( line, 3 ) > 6 THEN
            print( ( line, newline ) )
        FI
    OD;
    # close the file #
    close( input file )
FI
