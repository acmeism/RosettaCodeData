BEGIN # Kernighan's large earthquake problem - show lines from data.txt that #
      # record earthquakes greater than magnitude 6                          #

    PR read "files.incl.a68" PR     # include file utilities: EACHLINE, etc. #

    # return the real value of the specified field on the line               #
    PROC real field = ( STRING line, INT field )REAL:
         BEGIN
            REAL result  := 0;
            INT  c pos   := LWB line;
            INT  max pos  = UPB line;
            STRING f     := "";
            FOR f ield number TO field WHILE c pos <= max pos AND f = "" DO
                # skip leading spaces #
                WHILE IF c pos > max pos THEN FALSE ELSE line[ c pos ] = " " FI DO
                    c pos +:= 1
                OD;
                IF c pos <= max pos THEN                      # have a field #
                    INT start pos = c pos;
                    WHILE IF c pos > max pos THEN FALSE ELSE line[ c pos ] /= " " FI DO
                        c pos +:= 1
                    OD;
                    IF field number = field THEN   # have the required field #
                        f := line[ start pos : c pos - 1 ]
                    FI
                FI
            OD;
            IF f /= "" THEN
                # have the field - assume it a real value and convert it     #
                FILE real value;
                associate( real value, f );
                on value error
                    ( real value
                    , ( REF FILE ef )BOOL:      # "handles" ibvalid datq and #
                                     BEGIN      # returns TRUE so processing #
                                         result := 0;         # can continue #
                                         TRUE
                                     END
                     );
                get( real value, ( result ) );
                close( real value )
            FI;
            result
         END # real field # ;
    # shows line if its third field is > 6, returns TRUE if it is            #
    PROC show large earthquake = ( STRING line, INT count so far )BOOL:
         IF real field( line, 3 ) > 6 THEN
            print( ( line, newline ) );
            TRUE
         ELSE
            FALSE
         FI # show large earthquake # ;

    IF   "data.txt" EACHLINE show large earthquake < 0
    THEN print( ( "Unable to open data.txt", newline ) )
    FI

END
