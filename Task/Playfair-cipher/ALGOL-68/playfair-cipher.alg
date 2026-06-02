BEGIN # playfair cipher - translation of FreeBASIC #

    INT no q = 1, i equals j = 2; # possible values of pfo #
    INT pf max = 5;               # playfair table size    #

    MODE PLAYFAIR = STRUCT( INT pfo, [ 1 : pf max, 1 : pf max ]INT table );

    OP   TOUPPER = ( CHAR c )CHAR: IF c < "a" OR c > "z" THEN c ELSE REPR ( ABS c - ABS "a" + ABS "A" ) FI;
    OP   TOUPPER = ( STRING s )STRING:
         BEGIN
            STRING result := s;
            FOR r pos FROM LWB result TO UPB result DO result[ r pos ] := TOUPPER result[ r pos ] OD;
            result
         END # TOUPPER # ;
    PROC line input = ( STRING prompt )STRING:
         BEGIN
            STRING result;
            print( ( prompt ) );
            read( ( result, newline ) );
            result
         END # line input # ;

    PRIO NEWPLAYFAIR = 9;
    OP   NEWPLAYFAIR = ( INT pfo, STRING keyword )REF PLAYFAIR:
         BEGIN
            [ 1 : pf max, 1 : pf max ]INT table;
            [ 1 : 26 ]BOOL used; FOR i TO 26 DO used[ i ] := FALSE OD;
            used[ IF pfo = no q THEN 17 ELSE 10 FI ] := TRUE;
            STRING alphabet = TOUPPER keyword + "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            INT i := 1, j := 1, c;
            FOR k FROM LWB alphabet TO UPB alphabet WHILE i <= pf max DO
                c := ABS alphabet[ k ] - 64;
                IF c >= 1 AND c <= 26 THEN
                    IF NOT used[ c ] THEN
                        table[ i, j ] := c;
                        used[ c ] := TRUE;
                        j +:= 1;
                        IF j > pf max THEN
                            i +:= 1;
                            j  := 1
                        FI
                    FI
                FI
            OD;
            HEAP PLAYFAIR := PLAYFAIR( pfo, table )
         END # NEWPLAYFAIR # ;
    OP   NEWPLAYFAIR = ( BOOL ignore q, STRING keyword )REF PLAYFAIR:
         IF ignore q THEN no q ELSE i equals j FI NEWPLAYFAIR keyword;

    PROC get clean text = ( INT pfo, STRING orig text )STRING:
         BEGIN
            STRING plain text = TOUPPER orig text; # ensure everything is upper case #
            # get rid of any non-letters and insert X between duplicate letters #
            STRING clean text := "";
            CHAR prev char    := " ";
            FOR i FROM LWB plain text TO UPB plain text DO
                CHAR next char := plain text[ i ];
                IF    next char >= "A" AND next char <= "Z"
                AND ( next char /= "Q" OR pfo /= no q ) # Q should be omitted if no q option is specified #
                THEN
                    # If i equals j option specified, replace J with I #
                    IF next char = "J" AND pfo = i equals j THEN next char := "I" FI;
                    clean text +:= IF next char /= prev char THEN
                                       next char
                                   ELSE
                                       "X" + next char
                                   FI;
                    prev char := next char
                FI
            OD;
            IF ODD ( UPB clean text - LWB clean text + 1 ) THEN
                # dangling letter at end so add another letter to complete digram #
                clean text +:= IF clean text[ UPB clean text ] /= "X" THEN "X" ELSE "Z" FI
            FI;
            clean text
         END # get clean text # ;

    PROC find char = ( [,]INT table, INT c, REF INT row, col )VOID:
         BEGIN
            BOOL found := FALSE;
            row := 1 LWB table - 1;
            col := 2 UPB table + 1;
            FOR i FROM 1 LWB table TO 1 UPB table WHILE NOT found DO
                FOR j FROM 2 LWB table TO 2 UPB table WHILE NOT found DO
                    IF found := table[ i, j ] = c THEN
                        row := i;
                        col := j
                    FI
                OD
            OD
         END # find char # ;

    PRIO ENCODE = 9;
    OP   ENCODE = ( REF PLAYFAIR pf, STRING plain text )STRING:
         BEGIN
            STRING clean text   = get clean text( pfo OF pf, plain text );
            STRING cipher text := "";
            FOR i FROM LWB clean text BY 2 TO UPB clean text DO
                INT char1 = ABS clean text[ i     ] - 64;
                INT char2 = ABS clean text[ i + 1 ] - 64;
                INT row1 := 0, row2 := 0, col1 := 0, col2 := 0;
                find char( table OF pf, char1, row1, col1 );
                find char( table OF pf, char2, row2, col2 );
                cipher text
                    +:= IF row1 = row2
                        THEN REPR ( ( table OF pf )[ row1, col1 MOD pf max + 1 ] + 64 )
                           + REPR ( ( table OF pf )[ row2, col2 MOD pf max + 1 ] + 64 )
                        ELIF col1 = col2
                        THEN REPR ( ( table OF pf )[ row1 MOD pf max + 1, col1 ] + 64 )
                           + REPR ( ( table OF pf )[ row2 MOD pf max + 1, col2 ] + 64 )
                        ELSE REPR ( ( table OF pf )[ row1,                col2 ] + 64 )
                           + REPR ( ( table OF pf )[ row2,                col1 ] + 64 )
                        FI
                      + " " # the final digram should not have a trailing space #
                            # - it is removed later                             #
            OD;
            cipher text[ LWB cipher text : UPB cipher text - 1 ]
         END # ENCODE # ;

    PRIO DECODE = 9;
    OP   DECODE = ( REF PLAYFAIR pf, STRING cipher text )STRING:
         BEGIN
            STRING decoded text := "";
            # cipherText will include spaces so we need to skip them #
            FOR i FROM LWB cipher text BY 3 TO UPB cipher text DO
                INT char1 = ABS cipher text[ i     ] - 64;
                INT char2 = ABS cipher text[ i + 1 ] - 64;
                INT row1 := 0, row2 := 0, col1 := 0, col2 := 0;
                find char( table OF pf, char1, row1, col1 );
                find char( table OF pf, char2, row2, col2 );
                decoded text
                    +:= IF row1 = row2
                        THEN REPR ( ( table OF pf )[ row1, IF col1 > 1 THEN col1 - 1 ELSE pf max FI ] + 64 )
                           + REPR ( ( table OF pf )[ row2, IF col2 > 1 THEN col2 - 1 ELSE pf max FI ] + 64 )
                        ELIF col1 = col2
                        THEN REPR ( ( table OF pf )[ IF row1 > 1 THEN row1 - 1 ELSE pf max FI, col1 ] + 64 )
                           + REPR ( ( table OF pf )[ IF row2 > 1 THEN row2 - 1 ELSE pf max FI, col2 ] + 64 )
                        ELSE REPR ( ( table OF pf )[ row1,                                     col2 ] + 64 )
                           + REPR ( ( table OF pf )[ row2,                                     col1 ] + 64 )
                        FI
                      + " " # the final digram should not have a trailing space #
                            # - it is removed later                             #
            OD;
            decoded text[ LWB decoded text : UPB decoded text - 1 ]
         END # DECODE # ;


    BEGIN
        STRING keyword  := line input( "Enter Playfair keyword : " );
        BOOL   ignore q := FALSE;
        WHILE
            STRING q option := TOUPPER line input( "Ignore Q when buiding table  y/n : " );
            ignore q := q option = "Y";
            q option /= "Y" AND q option /= "N"
        DO SKIP OD;

        REF PLAYFAIR pf = ignore q NEWPLAYFAIR keyword;

        print( ( "The table to be used is : ", newline ) );
        FOR i FROM 1 LWB table OF pf TO 1 UPB table OF pf DO
            FOR j FROM 2 LWB table OF pf TO 2 UPB table OF pf DO
                print( ( REPR ( ABS ( table OF pf )[ i, j ] + 64 ), " " ) )
            OD;
            print( ( newline ) )
        OD;

        print( ( newline ) );
        STRING plain text = line input( "Enter plain text : " );
        STRING encoded text = pf ENCODE plain text;
        STRING decoded text = pf DECODE encoded text;

        print( ( newline ) );
        print( ( "Encoded text is : ",  encoded text, newline ) );
        print( ( "Decoded text is : ",  decoded text, newline ) )
    END
END
