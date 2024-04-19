BEGIN # subsitiution cipher #
                            #  abcdefghijklmnopqrstuvwxyz   #
    STRING substitute lower = "dthnxkmqrwzseglyoaubjpcfiv";
    STRING substitute upper = "TKXMGVUPOIRFDEJZNYWCAQSLBH";
                            #  ABCDEFGHIJKLMNOPQRSTUVWXYZ   #

    PROC encrypt = ( STRING plain text )STRING:
         BEGIN
            PROC encode = ( CHAR c, base, STRING code )CHAR:
                 code[ ( ABS c - ABS base ) + LWB code ];
            STRING result := plain text;
            FOR pos FROM LWB result TO UPB result DO
                CHAR c = result[ pos ];
                IF   c >= "A" AND c <= "Z" THEN
                    result[ pos ] := encode( c, "A", substitute upper )
                ELIF c >= "a" AND c <= "z" THEN
                    result[ pos ] := encode( c, "a", substitute lower )
                FI
            OD;
            result
         END # encrypt # ;

    PROC decrypt = ( STRING cipher text )STRING:
         BEGIN
            PROC decode = ( CHAR c, base, STRING code )CHAR:
                 BEGIN
                    INT c pos := 0;
                    char in string( c, c pos, code );
                    REPR ( ABS base + ( c pos - 1 ) )
                 END # decode # ;
            STRING result := cipher text;
            FOR pos FROM LWB result TO UPB result DO
                CHAR c = result[ pos ];
                IF c >= "A" AND c <= "Z" THEN
                    result[ pos ] := decode( c, "A", substitute upper )
                ELIF c >= "a" AND c <= "z" THEN
                    result[ pos ] := decode( c, "a", substitute lower )
                FI
            OD;
            result
         END # decrypt # ;

    PROC test cipher = ( STRING plain text )VOID:
         IF STRING encoded = encrypt( plain text );
            STRING decoded = decrypt( encoded );
            print( ( plain text, " -> ", encoded, newline ) );
            print( ( encoded,    " -> ", decoded, newline ) );
            decoded /= plain text
         THEN
            print( ( "**** encode/decode problem", newline ) )
         FI # test cipher # ;

    test cipher( "Sphinx of Black Quartz, judge my vow" );
    test cipher( "ABCDEFGHIJKLMNOPQRSTUVWXYZzyxwvutsrqponmlkjihgfedcba" )

END
