BEGIN # Rosetta Code "ABC incremental counts" task                               #

    PR read "sort.incl.a68" PR                          # include file utilities #

    [ 1 : 0 ]STRING empty list;

    # return the words from dictionary that contain required characters with the #
    # character counts matching the expected counts ( though not necessarily in  #
    # the same order as required characters ), the words will be treated as case #
    # sensitive or not, depending on case sensitive                              #
    PROC iwords = ( STRING dictionary, required characters
                  , []INT  expected counts
                  , BOOL   case sensitive
                  )[]STRING:
         IF FILE input file;
            STRING file name = dictionary;
            open( input file, file name, stand in channel ) /= 0
         THEN                                          # failed to open the file #
            print( ( "Unable to open """ + file name + """", newline ) );
            empty list
         ELSE                                                   # file opened OK #
            BOOL at eof := FALSE;
            on logical file end( input file   # set the EOF handler for the file #
                                     # notes that EOF reached and returns TRUE   #
                                     # so processing can continue                #
                               , ( REF FILE f )BOOL: at eof := TRUE
                               );

            # returns the counts of each character in c that is in s             #
            PRIO COUNT = 5;
            OP   COUNT = ( STRING s, c )[]INT:
                 BEGIN
                    [ LWB c : UPB c ]INT result;
                    FOR i FROM LWB c TO UPB c DO result[ i ] := 0 OD;
                    FOR i FROM LWB s TO UPB s DO
                        INT c pos := 0;
                        IF char in string( s[ i ], c pos, c ) THEN result[ c pos ] +:= 1 FI
                    OD;
                    result
                 END # COUNT # ;
            # returns TRUE if the corresponding elements of a equal those of b   #
            #         FALSE otherwise                                            #
            OP   = = ( []INT a, b )BOOL:
                 IF LWB a /= LWB b OR UPB a /= UPB b
                 THEN FALSE                                   # different bounds #
                 ELSE
                    BOOL same := TRUE;
                    FOR i FROM LWB a TO UPB a WHILE same := a[ i ] = b[ i ] DO SKIP OD;
                    same
                 FI # = # ;

            STRING characters = IF case sensitive
                                THEN required characters
                                ELSE TOLOWER required characters
                                FI;
            FLEX[ 1 : 100 ]STRING words;      # will be enlarged as required #

            [ LWB expected counts : UPB expected counts ]INT expected
                := expected counts;   # a sorted copy of the expected counts #
            expected QUICKSORT ELEMENTS( LWB expected, UPB expected );
            [ LWB expected counts : UPB expected counts ]INT actual;

            INT w count := 0;
            WHILE STRING word;
                  get( input file, ( word, newline ) );
                  NOT at eof
            DO                                           # have another word #
               IF case sensitive THEN word := TOLOWER word FI;
               IF actual := word COUNT characters; # get and sort the counts #
                  actual QUICKSORT ELEMENTS( LWB actual, UPB actual );
                  expected = actual
               THEN            # word has the expected pattern of characters #
                  w count +:= 1;
                  IF w count > UPB words THEN              # need more words #
                      [ 1 : UPB words ]STRING current words := words;
                      words := HEAP[ 1 : UPB words * 2 ]STRING;
                      words[ 1 : UPB current words ] := current words
                  FI;
                  words[ w count ] := word
               FI
            OD;
            words[ 1 : w count ]
         FI # iwords # ;

    # returns c converted to lowercase if it is uppercase, c otherwise           #
    OP   TOLOWER = ( CHAR c )CHAR:
         IF c >= "A" AND c <= "Z" THEN REPR( ( ABS c - ABS "A" ) + ABS "a" ) ELSE c FI;
    # returns s converted to lowercase                                           #
    OP   TOLOWER = ( STRING s )STRING:
         BEGIN
            STRING result := s;
            FOR r pos FROM LWB result TO UPB result DO result[ r pos ] := TOLOWER result[ r pos ] OD;
            result
         END # TOLOWER # ;

    # return the words from dictionary that contain required characters with the #
    # character counts (when sorted) differing by delta and with the minimum     #
    # count being min count; the words will be treated as case sensitive or not, #
    # depending on case sensitive                                                #
    PROC dwords = ( STRING dictionary, required characters
                  , INT    min count,  delta
                  , BOOL   case sensitive
                  )[]STRING:
         IF INT len characters = 1 + ( UPB required characters - LWB required characters );
            len characters < 1
         THEN                                        # no characters specified ? #
            print( ( "At least one character to find required", newline ) );
            empty list
         ELSE
            # construct the expected counts based on min count and delta         #
            [ 1 : len characters ]INT expected counts;
            expected counts[ 1 ] := min count;
            FOR i FROM 2 TO len characters DO
                expected counts[ i ] := expected counts[ i - 1 ] + delta
            OD;
            # get the words from the dictionary file                             #
            iwords( dictionary, required characters, expected counts, case sensitive )
         FI # dwords # ;

    # returns s left-padded with blanks to w characters                          #
    PRIO PAD = 1;
    OP   PAD = ( INT w, STRING s )STRING:
         IF   INT len = ( UPB s - LWB s ) + 1;
              len >= w
         THEN s
         ELSE ( ( w - len ) * " " ) + s
         FI # PAD # ;
    # show the words found by dwords                                             #
    PROC show words = ( STRING dictionary, required characters
                      , INT    min count, delta
                      , BOOL   case sensitive
                      )VOID:
         BEGIN
            print( ( "Searching ", dictionary, " for """, required characters, """ words" ) );
            print( ( ", minimum count: ", whole( min count, 0 ) ) );
            IF delta /= 1 THEN print( ( ", delta: ", whole( delta, 0 ) ) ) FI;
            print( ( newline ) );
            []STRING words
                = dwords( dictionary, required characters, min count, delta, case sensitive );
            INT n words = ( UPB words - LWB words ) + 1;
            IF n words = 0 THEN
                print( ( 32 PAD "<none>", newline, newline ) )
            ELSE
                FOR w FROM LWB words TO UPB words DO
                    IF ODD w
                    THEN print( ( 32 PAD words[ w ] ) )
                    ELSE print( ( " ", words[ w ], newline ) )
                    FI
                OD;
                IF ODD n words THEN print( ( newline ) ) FI;
                print( ( newline ) )
            FI
         END # show words # ;

    # task test cases                                                            #
    show words( "unixdict.txt",    "abc", 1, 1, FALSE );
    show words( "unixdict.txt",    "the", 1, 1, FALSE );
    show words( "unixdict.txt",    "cio", 2, 1, FALSE );

    show words( "words_alpha.txt", "abc", 2, 1, FALSE );
    show words( "words_alpha.txt", "the", 2, 1, FALSE );
    show words( "words_alpha.txt", "cio", 3, 1, FALSE );

    show words( "words_alpha.txt", "abc", 2, 0, FALSE )

END
