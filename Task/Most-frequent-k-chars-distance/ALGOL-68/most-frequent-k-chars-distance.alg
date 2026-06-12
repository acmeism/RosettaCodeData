BEGIN # "Most frequent k chars distance": translation of the FreeBASIC sample,   #
      # but retains the original order of the characters with the same frequency #

    MODE OCCURANCE = STRUCT( CHAR ch, INT count, INT pos );

    PROC most freq k hashing = ( STRING input string, INT k )[]OCCURANCE:
         BEGIN
            [ ABS "A" : ABS "Z" ]INT dict, orig pos;
            FOR n FROM LWB dict TO UPB dict DO dict[ n ] := orig pos[ n ] := 0 OD;
            FOR n FROM LWB input string TO UPB input string DO
                INT c = IF   CHAR ch = input string[ n ];
                             ch >= "A" AND ch <= "Z"
                        THEN ABS ch
                        ELIF ch >= "a" AND ch <= "z"
                        THEN ABS "A" + ( ABS ch - ABS "a" )
                        ELSE 0
                        FI;
                IF c > 0 THEN
                    dict[ c ] +:= 1;
                    IF orig pos[ c ] = 0 THEN orig pos[ c ] := n FI
                FI
            OD;
            INT count := 0;
            FOR n FROM LWB dict TO UPB dict DO
                IF dict[ n ] > 0 THEN count +:= 1 FI
            OD;
            [ 1 : count ]OCCURANCE result;
            INT r pos := 0;
            FOR n FROM LWB dict TO UPB dict DO
                IF dict[ n ] > 0 THEN
                    result[ r pos +:= 1 ] := ( REPR n, dict[ n ], orig pos[ n ] )
                FI
            OD;
            # Sort the output dict on descending count and ascending original position #
            FOR n FROM LWB result TO UPB result - 1 DO
                FOR j FROM n + 1 TO UPB result DO
                    IF     count OF result[ j ] > count OF result[ n ]
                    OR (   count OF result[ j ] = count OF result[ n ]
                       AND   pos OF result[ j ] <   pos OF result[ n ]
                       )
                    THEN OCCURANCE t  = result[ j ];
                         result[ j ] := result[ n ];
                         result[ n ] := t
                    FI
                OD
            OD;
            # Keep only the top K elements #
            IF UPB result > k THEN result[ 1 : k ] ELSE result FI
         END # most freq k hashing # ;

     PROC most freq k similarity = ( []OCCURANCE input str1, input str2 )INT:
          BEGIN
             INT similarity := 0;
             FOR n FROM LWB input str1 TO UPB input str1 DO
                 FOR j FROM LWB input str2 TO UPB input str2 DO
                     IF ch OF input str1[ n ] = ch OF input str2[ j ] THEN
                         similarity +:= count OF input str1[ n ] + count OF input str2[ j ]
                     FI
                 OD
             OD;
             similarity
          END # most freq k similarity # ;

    PROC most freq ksdf = ( STRING input str1, input str2, INT k, max distance )INT:
         max distance - most freq k similarity( most freq k hashing( input str1, k )
                                              , most freq k hashing( input str2, k )
                                              );

    OP   SHOW = ( []OCCURANCE dict )VOID:
         FOR j FROM LWB dict TO UPB dict DO
             print( ( ch OF dict[ j ], whole( count OF dict[ j ], 0 ) ) )
         OD # SHOW # ;

    PROC test ksdf = ( STRING str1, str2, INT k, max distance )VOID:
         BEGIN
            []OCCURANCE dict1 = most freq k hashing( str1, k );
            []OCCURANCE dict2 = most freq k hashing( str2, k );
            print( ( "dict1: " ) ); SHOW dict1; print( ( " from: ", str1, newline ) );
            print( ( "dict2: " ) ); SHOW dict2; print( ( " from: ", str2, newline ) );
            print( ( "MostFreqKSDF: " ) );
            print( ( whole( most freq ksdf( str1, str2, k, max distance ), 0 ) ) );
            print( ( newline, newline ) )
         END # test ksdf # ;

    # test cases #
    test ksdf( "night",       "nacht",        2, 10 );
    test ksdf( "my",          "a",            2, 10 );
    test ksdf( "research",    "research",     2, 10 );
    test ksdf( "significant", "capabilities", 2, 10 );
    test ksdf( "LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV"
             , "EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG"
             , 2, 100
             )
END
