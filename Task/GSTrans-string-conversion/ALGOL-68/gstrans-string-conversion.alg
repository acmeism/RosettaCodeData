BEGIN # GSTrans string conversion                                            #
    OP   UNQUOTE = ( STRING s )STRING:                  # returns s unquoted #
         IF LWB s >= UPB s THEN s
         ELIF s[ LWB s ] /= """" OR s[ UPB s ] /= """" THEN s
         ELSE s[ LWB s + 1 : UPB s - 1 ]
         FI # UNQUOTE # ;
    OP   ENCODE = ( STRING str )STRING:                # returns str encoded #
         BEGIN
            STRING result := "";
            STRING s       = UNQUOTE str;
            FOR i FROM LWB s TO UPB s DO
                INT c = ABS s[ i ];
                result +:= IF   c < 32 THEN
                                "|" + REPR ( c + 64 )
                           ELIF c = ABS """" OR c = ABS "|" THEN
                               "|" + s[ i ]
                           ELIF c >= 32 AND c <= 126 THEN
                                s[ i ]
                           ELIF c = 127 THEN
                                "|?"
                           ELSE
                                "|!" + ENCODE STRING( REPR( c - 128 ) )
                           FI

            OD;
            IF s /= str THEN """" + result + """" ELSE result FI
         END # ENCODE # ;
    OP   DECODE = ( STRING str )STRING:                # returns str decoded #
         BEGIN
            STRING result := "";
            STRING s       = UNQUOTE str;
            INT i := LWB s;
            WHILE i <= UPB s DO
                result +:= IF   s[ i ] /= "|" THEN
                                s[ i ]
                           ELIF ( i +:= 1 ) > UPB s THEN
                                ""
                           ELIF s[ i ] = """" OR s[ i ] = "|" THEN
                                s[ i ]
                           ELIF s[ i ] = "?" THEN
                                REPR 127
                           ELIF s[ i ] /= "!" THEN
                                INT ch = ABS s[ i ] - 64;
                                IF ch < 0 THEN s[ i ] ELSE REPR ch FI
                           ELSE
                                i +:= 1;
                                IF   i > UPB s THEN
                                     ""
                                ELIF s[ i ] /= "|" THEN
                                     INT ch = ABS s[ i ] + 128;
                                     IF ch > 255 THEN s[ i ] ELSE REPR ch FI
                                ELIF ( i +:= 1 ) > UPB s THEN
                                     ""
                                ELSE
                                     STRING c = DECODE STRING( "|" + s[ i ] );
                                     INT ch = ABS c[ LWB c ] + 128;
                                     IF ch > 255 THEN s[ i ] ELSE REPR ch FI
                                FI
                           FI;
                  i +:= 1
            OD;
            IF s /= str THEN """" + result + """" ELSE result FI
         END # DECODE # ;
    OP   SHOWBYTES = ( STRING s )STRING:  # return s with control characters #
         BEGIN                            # replaced by their value          #
            STRING result := "";
            FOR i FROM LWB s TO UPB s DO
                INT c = ABS s[ i ];
                result +:= IF c < 32 THEN
                               "[" + whole( c, 0 ) + "]"
                           ELSE
                               s[ i ]
                           FI
             OD;
             result
          END # SHOWBYTES # ;

    []STRING test = ( "ALERT|G",    "wert↑",       "@♂aN°$ª7Î"    # test cases #
                    , "ÙC▼æÔt6¤☻Ì", """@)Ð♠qhýÌÿ", "+☻#o9$u♠©A" # from Julia #
                    , "♣àlæi6Ú.é",  "ÏÔ♀È♥@ë",     "Rç÷\%◄MZûhZ"
                    , "ç>¾AôVâ♫↓P"
                    , REPR 12 + "Hello" + REPR 7 + REPR 10 + REPR 13 # Task test cases  #
                    , REPR 13 + REPR 10 + REPR 0 + REPR 5 + REPR 244 + REPR 13 + REPR 255
                    , """quoted|text"""                              # quoted test case #
                    );
    FOR i FROM LWB test TO UPB test DO
        STRING encoded = ENCODE test[ i ];
        STRING decoded = DECODE encoded;
        print( ( SHOWBYTES test[ i ], " -> ", encoded, " -> ", SHOWBYTES decoded
               , IF decoded = test[ i ] THEN "" ELSE " ****" FI, newline
               )
             )
    OD;
    STRING invalid = "|=|1|!";
    print( ( "Decoding: ", invalid, " -> ", DECODE invalid, newline ) )
END
