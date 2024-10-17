BEGIN # Bifid cipher                                                         #

    # mode to hold the details of a Bifid cipher                             #
    MODE BIFID = STRUCT( STRING key        # the Polybius square, linearised #
                       , STRING pre from    # pre-translation, "from" string #
                       , STRING pre to        # pre-tramslatiion "to" string #
                       );

    # string utilities                                                       #

    # returns the length of s                                                #
    OP   LENGTH = ( STRING s )INT: ( UPB s - LWB s ) + 1;
    # returns the index of c in s, or LWB s - 1 if it is not present         #
    PRIO INDEXOF = 1;
    OP   INDEXOF = ( STRING s, CHAR c )INT:
         BEGIN
            INT index := LWB s - 1;
            VOID( char in string( c, index, s ) );      # discard the result #
            index
         END # INDEXOF # ;
    # returns text with the characters in from chars replaced with the       #
    #         corresponding characters in to chars                           #
    PROC translate = ( STRING text, from chars, to chars )STRING:
         IF   LWB from chars /= LWB to chars OR UPB from chars /= UPB to chars
         THEN """from"" and ""to"" have different bounds (translate)"
         ELIF from chars = ""
         THEN text
         ELSE # the from and to strings have the same bounds                 #
              STRING result := text;
              FOR r pos FROM LWB result TO UPB result DO
                  INT t pos = from chars INDEXOF result[ r pos ];
                  IF  t pos >= LWB from chars THEN result[ r pos ] := to chars[ t pos ] FI
              OD;
              result
         FI # translate # ;
    # end string utilities                                                   #

    # returns text encrypted according to cipher                             #
    PRIO ENCRYPT = 9;
    OP   ENCRYPT = ( STRING text, BIFID cipher )STRING:
         IF   STRING key     = ( key OF cipher )[ AT 1 ];
              INT key length = LENGTH key;
              INT sq width   = ENTIER sqrt( key length );
              sq width * sq width /= key length
         THEN "**** Bifid key is not a square"
         ELSE # the key is a square                                          #
              STRING msg1  = translate( text, pre from OF cipher, pre to OF cipher )[ AT 1 ];
              STRING msg  := "";
              FOR m pos FROM LWB msg1 TO UPB msg1 DO
                  IF msg1[ m pos ] /= " " THEN msg +:= msg1[ m pos ] FI
              OD;
              INT    m max = LENGTH msg;
              [ 1 : 2 * m max ]INT coordinates;
              FOR m pos TO m max DO
                  INT c index := key INDEXOF msg[ m pos ];
                  IF  c index >= LWB key THEN c index -:= 1 FI;
                  coordinates[ m pos         ] := c index OVER sq width;
                  coordinates[ m pos + m max ] := c index MOD  sq width
              OD;
              STRING result := "";
              FOR c pos BY 2 TO UPB coordinates DO
                  result +:= key[ ( coordinates[ c pos     ] * sq width )
                                +   coordinates[ c pos + 1 ]
                                + 1
                                ]
              OD;
              result
         FI # ENCRYPT # ;

    # returns text decrypted according to cipher                             #
    PRIO DECRYPT = 9;
    OP   DECRYPT = ( STRING text, BIFID cipher )STRING:
         IF   STRING key     = ( key OF cipher )[ AT 1 ];
              INT key length = LENGTH key;
              INT sq width   = ENTIER sqrt( key length );
              sq width * sq width /= key length
         THEN "**** Bifid key is not a square"
         ELSE # the key is a square                                          #
              STRING msg   = text[ AT 1 ];
              INT    m max = LENGTH msg;
              [ 1 : 2 * m max ]INT coordinates;
              INT c pos := 0;
              FOR m pos TO m max DO
                  INT c index := key INDEXOF msg[ m pos ];
                  IF  c index >= LWB key THEN c index -:= 1 FI;
                  coordinates[ c pos +:= 1 ] := c index OVER sq width;
                  coordinates[ c pos +:= 1 ] := c index MOD  sq width
              OD;
              STRING result := "";
              FOR i TO m max DO
                  result +:= key[ ( coordinates[ i         ] * sq width )
                                +   coordinates[ i + m max ]
                                + 1
                                ]
              OD;
              result
         FI # DECRYPT # ;

    # tests the ENCRYPT and DECRYPT operators                                #
    PROC test bifid = ( BIFID cipher, STRING text )VOID:
         BEGIN
            STRING code = text ENCRYPT cipher;
            print( ( text, " -> ", code,                newline ) );
            print( ( code, " -> ", code DECRYPT cipher, newline ) )
         END # text bifid # ;

    # Bifid ciphers for tests                                                #

    BIFID bifid 5 abc = ( "ABCDEFGHIKLMNOPQRSTUVWXYZ"
                        , "Jabcdefghijklmnopqrstuvwxyz"
                        , "IABCDEFGHIIKLMNOPQRSTUVWXYZ"
                        );
    BIFID bifid 5 bgw = ( "BGWKZQPNDSIOAXEFCLUMTHYVR"
                        , "Jabcdefghijklmnopqrstuvwxyz"
                        , "IABCDEFGHIIKLMNOPQRSTUVWXYZ"
                        );
    BIFID bifid 6 abc = ( "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                        , "abcdefghijklmnopqrstuvwxyz"
                        , "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                        );
    BIFID bifid 8 abc = ( "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789\/"
                        , " "
                        , "/"
                        );

    # basic task - using 5x5 Polybius squares                                #
    test bifid( bifid 5 abc, "ATTACKATDAWN" );
    print( ( newline ) );
    test bifid( bifid 5 bgw, "FLEEATONCE" );
    test bifid( bifid 5 bgw, "ATTACKATDAWN" );
    test bifid( bifid 5 bgw, "The invasion will begin on the first of January" );
    print( ( newline ) );

    # bonus - using a 6x6 square                                             #
    test bifid( bifid 6 abc, "The invasion will begin on the first of January" );
    print( ( newline ) );

    # bonus - using an 8x8 square                                            #
    test bifid( bifid 8 abc, "The invasion will begin on the first of January" )

END
