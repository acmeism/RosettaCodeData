# remove control characters and optionally extended characters from the string text  #
# assums ASCII is the character set                                                  #
PROC strip characters = ( STRING text, BOOL strip extended )STRING:
     BEGIN
         # we build the result in a []CHAR and convert back to a string at the end #
         INT text start = LWB text;
         INT text max   = UPB text;
         [ text start : text max ]CHAR result;
         INT result pos := text start;
         FOR text pos FROM text start TO text max DO
             INT ch := ABS text[ text pos ];
             IF ( ch >= 0 AND ch <= 31 ) OR ch = 127 THEN
                 # control character #
                 SKIP
             ELIF strip extended AND ( ch > 126 OR ch < 0 ) THEN
                 # extened character and we don't want them #
                 SKIP
             ELSE
                 # include this character #
                 result[ result pos ] := REPR ch;
                 result pos +:= 1
             FI
         OD;
         result[ text start : result pos - 1 ]
     END # strip characters # ;

# test the control/extended character stripping procedure #
STRING t = REPR 2 + "abc" + REPR 10 + REPR 160 + "def~" + REPR 127 + REPR 10 + REPR 150 + REPR 152 + "!";
print( ( "<<" + t + ">> - without control characters:             <<" + strip characters( t, FALSE ) + ">>", newline ) );
print( ( "<<" + t + ">> - without control or extended characters: <<" + strip characters( t, TRUE  ) + ">>", newline ) )
