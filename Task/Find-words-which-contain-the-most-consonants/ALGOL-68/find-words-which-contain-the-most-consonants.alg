BEGIN # find words longer than 10 characters that contain unique consonants  #
      # and sort them by the number of consonants they contain               #

    PR read "files.incl.a68" PR                      # include file utilities #
    PR read  "sort.incl.a68" PR                      # include sort utilities #


    # returns the length of s                                                #
    OP   LENGTH     = ( STRING s )INT: 1 + ( UPB s - LWB s );
    # returns the consonant count of s or 0 if the consonants are not unique #
    OP   UNIQUECONSONANTS = ( STRING s )INT:
         BEGIN
            [ 0 : 26 ]INT count;
            FOR c FROM LWB count TO UPB count DO count[ c ] := 0 OD;
            FOR i FROM LWB s TO UPB s DO
                CHAR c := s[ i ];
                IF c >= "A" AND c <= "Z" THEN
                    c := REPR ( ABS c + ( ABS "a" - ABS "A" ) )
                FI;
                IF c >= "b" AND c <= "z" THEN
                    IF c /= "e" AND c /= "i" AND c /= "o" AND c /= "u" THEN
                       count[ ABS c - ABS "a" ] +:= 1
                    FI
                FI
            OD;
            BOOL all unique := TRUE;
            INT  consonants := 0;
            FOR c FROM LWB count TO UPB count WHILE all unique := count[ c ] < 2 DO
                consonants +:= count[ c ]
            OD;
            IF all unique THEN consonants ELSE 0 FI
         END # UNIQUECONSONANTS # ;

    [ 1 : 2 000 ]STRING words;
    INT max length := 0;

    # returns TRUE if word is longer than 10 characters and contains         #
    #         consonants that only occur once, FALSE otherwise               #
    # if the result is TRUE, the word is added to words, prefixed with the   #
    # max abs char complement of the number of consonants                    #
    # count so far will contain the number of such words found so far        #
    # max length is set to the length of the longest such word encountered   #
    PROC store unique consonant words = ( STRING word, INT count so far )BOOL:
         IF   INT w length = LENGTH word;
              w length <= 10
         THEN FALSE                                      # word is too short #
         ELIF INT consonants = UNIQUECONSONANTS word;
              consonants <= 0
         THEN FALSE        # word has non-unique consonents or no consonants #
         ELSE # word is long enough to include and contains only uniue       #
              # consonants, store it prefixed by the max abs char complement #
              # of the number of consonants in it, so we can sort the words  #
              #into reverse consonant count order                            #
              words[ count so far + 1 ] := REPR ( max abs char - consonants ) + word;
              IF w length > max length THEN max length := w length FI;
              TRUE
         FI # store unique consonant words # ;

    IF   INT w count    = "unixdict.txt" EACHLINE store unique consonant words;
         w count < 0
    THEN print( ( "Unable to open unixdict.txt", newline ) )
    ELSE words QUICKSORT ELEMENTS( 1, w count );            # sort the words #
         INT prev count  := 0;                           # display the words #
         INT p count     := 0;
         BOOL need nl    := FALSE;
         FOR w TO w count DO
            STRING s word   = words[ w ];
            INT    count    = max abs char - ABS s word[ 1 ];
            STRING word     = s word[ 2 : ];
            INT    w length = LENGTH word;
            IF count /= prev count THEN
                IF need nl THEN print( ( newline ) ) FI;
                print( ( newline, whole( count, 0 ), " consonants:", newline ) );
                prev count := count;
                p count    := 0;
                need nl    := FALSE
            FI;
            TO max length - w length DO print( ( " " ) ) OD;
            print( ( " ", word ) );
            IF NOT ( need nl := ( p count +:= 1 ) MOD 5 /= 0 ) THEN
                print( ( newline ) )
            FI
         OD
    FI

END
