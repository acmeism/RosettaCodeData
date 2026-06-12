BEGIN # print some Latin verb conjugations #
    PROC s length = ( STRING s )INT: ( UPB s + 1 ) - LWB s;      # calculates the length of s #
    # prints the cojugations of lv or an error message if we don't know how to conjugate lv #
    PROC print conjugations = ( STRING lv )VOID:
         IF   []STRING ending    = ( "are", "ēre", "ere", "ire" );
              INT length         = s length( lv );
              INT conjugation   := 0;
              INT ending length := 0;
              BOOL long enough  := FALSE;
              FOR i FROM LWB ending TO UPB ending WHILE conjugation = 0 DO
                  ending length := s length( ending[ i ] );
                  IF ending length < length
                  THEN
                      # the word is long enough for at least one ending #
                      long enough := TRUE;
                      IF lv[ ( UPB lv + 1 ) - ending length : ] = ending[ i ]
                      THEN
                          conjugation := i
                      FI
                  FI
              OD;
              NOT long enough
         THEN
              print( ( """", lv, """ is not long enough to conjugate", newline ) )
         ELIF conjugation = 0
         THEN
             print( ( "Don't know how to conjugate """, lv, """", newline ) )
         ELSE
             [,]STRING suffix =  ( (  "o", "as", "at", "amus", "atis",  "ant" )
                                 , ( "eo", "es", "et", "emus", "etis",  "ent" )
                                 , (  "o", "is", "it", "imus", "itis",  "unt" )
                                 , ( "io", "is", "it", "imus", "itis", "iunt" )
                                 );
             STRING prefix = lv[ : UPB lv - ending length ];
             print( ( "    Conjugations of """, lv, """:", newline ) );
             FOR i FROM 2 LWB suffix TO 2 UPB suffix DO
                 print( ( "        ", prefix, suffix[ conjugation, i ], newline ) )
             OD
         FI # print confugations # ;
    print( ( "Present Indicative conjugation:", newline ) );
    print conjugations( "amare"  );
    print conjugations( "monēre" );
    print conjugations( "tegere" );
    print conjugations( "venire" );
    print conjugations( "qwerty" );
    print conjugations( "are"    )
END
