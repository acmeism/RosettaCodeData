BEGIN # Sailors, coconuts a and a monkey problem - translation of Kotlin     #

    INT coconuts := 11;
    FOR ns FROM 2 TO 9 DO
        [ 1 : ns ]INT hidden; FOR i FROM 1 TO UPB hidden DO hidden[ i ] := 0 OD;
        coconuts := ( ( coconuts OVER ns ) * ns ) + 1;
        BOOL next ns := FALSE;
        WHILE NOT next ns DO
           INT  nc      := coconuts;
           BOOL break s := FALSE;
           FOR s TO ns WHILE NOT next ns AND NOT break s DO
               IF nc MOD ns = 1 THEN
                   hidden[ s ] := nc OVER ns;
                   nc -:= hidden[ s ] + 1;
                   IF s = ns AND nc MOD ns = 0 THEN
                       print( ( whole( ns, 0 ), " sailors require a minimum of " ) );
                       print( ( whole( coconuts, 0 ), " coconuts", newline ) );
                       FOR t TO ns DO
                           print( ( "    Sailor ", whole( t, 0 ) ) );
                           print( ( " hides ", whole( hidden[ t ], 0 ), newline ) )
                       OD;
                       print( ( "    The monkey gets ", whole( ns, 0 ), newline ) );
                       print( ( "    Finally, each sailor takes ", whole( nc OVER ns, 0 ) ) );
                       print( ( newline, newline ) );
                       next ns := TRUE
                   FI
               ELSE
                   break s := TRUE
               FI
           OD;
           IF NOT next ns THEN coconuts +:= ns FI
        OD
    OD

END
