# generate random sentences using text from a book as a basis        #

# use the associative array in the Associate array/iteration task    #
PR read "aArray.a68" PR

# returns s with chars removed                                       #
PRIO REMOVE = 1;
OP   REMOVE = ( STRING s, chars )STRING:
     BEGIN
        [ LWB s : UPB s ]CHAR result;
        INT r pos := LWB result - 1;
        FOR s pos FROM LWB s TO UPB s DO
            IF NOT char in string( s[ s pos ], NIL, chars ) THEN
                # have a character that needn't be removed           #
                r pos +:= 1;
                result[ r pos ] := s[ s pos ]
            FI
        OD;
        result[ LWB s : r pos ]
     END # REMOVE # ;
# returns text converted to an INT or -1 if text is not a number     #
OP   TOINT    = ( STRING text )INT:
     BEGIN
        INT  result     := 0;
        BOOL is numeric := TRUE;
        FOR ch pos FROM LWB text TO UPB text WHILE is numeric DO
            CHAR c = text[ ch pos ];
            is numeric := ( c >= "0" AND c <= "9" );
            IF is numeric THEN ( result *:= 10 ) +:= ABS c - ABS "0" FI
        OD;
        IF is numeric THEN result ELSE -1 FI
     END # TOINT # ;

# get the file name and number of words for the prefix and           #
# max number of words and sentences from the command line            #
STRING file name           := "twotw.txt";
STRING start word          := "";
INT    prefix length       := 2;
INT    number of sentences := 10;
INT    max words           := 1 000 000;
FOR arg pos TO argc - 1 DO
    STRING arg upper := argv( arg pos );
    FOR ch pos FROM LWB arg upper TO UPB arg upper DO
        IF is lower( arg upper[ ch pos ] ) THEN arg upper[ ch pos ] := to upper( arg upper[ ch pos ] ) FI
    OD;
    IF   arg upper  = "FILE"   THEN
        file name           :=       argv( arg pos + 1 )
    ELIF arg upper  = "PREFIX" THEN
        prefix length       := TOINT argv( arg pos + 1 )
    ELIF arg upper  = "SENTENCES" THEN
        number of sentences := TOINT argv( arg pos + 1 )
    ELIF arg upper  = "MAXWORDS" THEN
        max words           := TOINT argv( arg pos + 1 )
    ELIF arg upper  = "STARTWORD" THEN
        start word          :=       argv( arg pos + 1 )
    FI
OD;

# delimiter for separating suffixes - must not appear in the text    #
CHAR   suffix delimiter = REPR 1; # ^A #
STRING punctuation      = """'@,/;:(){}[]*&^%$";   # NB: exclude " " #

IF  FILE input file;
    open( input file, file name, stand in channel ) /= 0
THEN
    # failed to open the file #
    print( ( "Unable to open """ + file name + """", newline ) )
ELSE
    # file opened OK #
    BOOL at eof := FALSE;
    BOOL at eol := FALSE;
    # set the EOF handler for the file #
    on logical file end( input file
                       , ( REF FILE f )BOOL:
                         BEGIN
                             # note that we reached EOF on the #
                             # latest read #
                             at eof := TRUE;
                             # return TRUE so processing can continue #
                             TRUE
                         END
                       );
    # set the end-of-line handler for the file so get word can see line boundaries #
    on line end( input file
               , ( REF FILE f )BOOL:
                 BEGIN
                     # note we reached end-of-line #
                     at eol := TRUE;
                     # return FALSE to use the default eol handling  #
                     # i.e. just get the next charactefr             #
                     FALSE
                 END
               );
    CHAR   c    := " ";
    # returns the next word from input file                          #
    # a word is any sequence of characters separated by spaces and   #
    # suffix delimiters, or one of the characters ".", "!" or "?"    #
    PROC get word = STRING:
         IF at eof THEN ""
         ELSE # not at end of file                                   #
            STRING word := "";
            at eol := FALSE;
            IF c = "." OR c = "!" OR c = "?" THEN
                # sentence ending "word"                             #
                word := c;
                get( input file, ( c ) )
            ELSE
                # "normal" word                                      #
                WHILE ( c = " " OR c = suffix delimiter ) AND NOT at eof DO get( input file, ( c ) ) OD;
                WHILE c /= " "
                  AND c /= "."
                  AND c /= "!"
                  AND c /= "?"
                  AND c /= suffix delimiter
                  AND NOT at eol
                  AND NOT at eof
                DO
                    word +:= c;
                    get( input file, ( c ) )
                OD
            FI;
            at eol := FALSE;
            word
         FI # get word # ;

    # returns a random number between 1 and n inclusive              #
    PROC random choice = ( INT n )INT: IF n < 2 THEN n ELSE ENTIER ( ( next random * n ) + 1 ) FI;

    # chooses a suffix at random to continue a sentence              #
    PROC choose suffix = ( STRING sfxs )STRING:
         BEGIN
            # count the number of suffixes                           #
            INT suffix max := 0;
            FOR s pos FROM LWB sfxs TO UPB sfxs DO
               IF sfxs[ s pos ] = suffix delimiter THEN suffix max +:= 1 FI
            OD;
            # select a random suffix to continue the text with       #
            STRING sfx          := "";
            INT    prev pos     := LWB sfxs - 1;
            INT    suffix count := random choice( suffix max );
            FOR s pos FROM LWB sfxs TO UPB sfxs WHILE suffix count > 0  DO
                IF sfxs[ s pos ] = suffix delimiter THEN
                    # found the end of a suffix                      #
                    sfx           := sfxs[ prev pos + 1 : s pos - 1 @ 1 ];
                    prev pos      := s pos;
                    suffix count -:= 1
                FI
            OD;
            sfx
         END # choose suffix # ;

    # skip to the start word, if there is one                        #
    IF start word /= "" THEN WHILE NOT at eof AND get word /= start word DO SKIP OD FI;
    # get the first prefix from the file                             #
    [ prefix length ]STRING prefix;
    FOR p pos TO prefix length WHILE NOT at eof DO prefix[ p pos ] := get word OD;
    IF at eof THEN
        # not enough words in the file                               #
        print( ( file name, " contains less than ", whole( prefix length, 0 ), " words", newline ) )
    ELSE
        # have some words                                            #
        INT word count := prefix length;
        # store the prefixes and suffixes in the associatibe array   #
        # we store the suffix as a single concatenated               #
        # string delimited by suffix delimiters, the string will     #
        # have a leading delimiter                                   #
        # suffixes that appear multiple times in the input text will #
        # appear multiple time in the array, this will allow them to #
        # have a higher probability than suffixes that appear fewer  #
        # times                                                      #
        # this will use more memory than storing the sufixes and a   #
        # count, but simplifies the generation                       #
        # with a prefix length of 2 (as required by the task),       #
        # the War Of The Worlds can be processed - for longer prefix #
        # lengths a less memory hungry algorithm would be needed     #
        REF AARRAY suffixes := INIT LOC AARRAY;
        INT prefix count    := 0;
        WHILE NOT at eof AND word count <= max words
        DO
            # concatenate the prefix words to a single string        #
            STRING prefix text := prefix[ 1 ];
            FOR p pos FROM 2 TO prefix length DO prefix text +:= ( " " + prefix[ p pos ] ) OD;
            STRING suffix := get word;
            # if the prefix has no lower case, ignore it as it is    #
            # probably a chapter heading or similar                  #
            IF BOOL has lowercase := FALSE;
               FOR s pos FROM LWB prefix text TO UPB prefix text
               WHILE NOT ( has lowercase := is lower( prefix text[ s pos ] ) )
               DO SKIP OD;
               has lowercase
            THEN
                # the prefix contains some lower case                #
                # store the suffixes associated with the prefix      #
                IF NOT ( suffixes CONTAINSKEY prefix text ) THEN
                    # first time this prefix has appeared            #
                    prefix count +:= 1
                FI;
                IF prefix[ 1 ] = "." OR prefix[ 1 ] = "!" OR prefix[ 1 ] = "?" THEN
                    # have the start of a sentence                   #
                    suffixes // "*." +:= ( suffix delimiter + prefix text )
                FI;
                STRING prefix without punctuation = prefix text REMOVE punctuation;
                IF prefix without punctuation /= "" THEN prefix text := prefix without punctuation FI;
                suffixes // prefix text +:= ( suffix delimiter + suffix )
            FI;
            # shuffle the prefixes down one and add the new suffix   #
            # as the final prefix                                    #
            FOR p pos FROM 2 TO prefix length DO prefix[ p pos - 1 ] := prefix[ p pos ] OD;
            prefix[ prefix length ] := suffix;
            IF NOT at eof THEN word count +:= 1 FI
        OD;

        # generate text                                                  #
        TO number of sentences DO
            print( ( newline ) );
            # start with a random prefix                                 #
            STRING pfx      := choose suffix( suffixes // "*." );
            STRING line     := pfx[ @ 1 ][ 3 : ]; # remove the leading   #
                                                  #   ". " from the line #
            pfx             := pfx REMOVE punctuation;
            BOOL   finished := FALSE;
            WHILE NOT finished DO
                IF STRING sfxs := ( suffixes // pfx );
                   IF LWB sfxs <= UPB sfxs THEN
                       IF sfxs[ LWB sfxs ] = suffix delimiter THEN sfxs := sfxs[ LWB sfxs + 1 : ] FI
                   FI;
                   sfxs +:= suffix delimiter;
                   sfxs = suffix delimiter
                THEN
                    # no suffix - reached the end of the generated text  #
                    line +:= " (" + pfx + " has no suffix)";
                    finished := TRUE
                ELSE
                    # can continue to generate text                      #
                    STRING sfx = choose suffix( sfxs );
                    IF sfx = "." OR sfx = "!" OR sfx = "?"
                    THEN
                        # reached the end of a sentence                  #
                        finished := TRUE;
                        # if the line ends with ",;:", remove it         #
                        INT    line end := UPB line;
                        IF   CHAR end ch = line[ line end ];
                             end ch = "," OR end ch = ";" OR end ch = ":"
                        THEN line end -:= 1
                        FI;
                        # remove trailing spaces                         #
                        WHILE line[ line end ] = " " AND line end > LWB line DO line end -:= 1 OD;
                        line := line[ LWB line : line end ] + sfx
                    ELSE
                        # not at the end of the sentence                 #
                        line +:= " " + sfx;
                        # remove the first word from the prefix and add  #
                        # the suffix                                     #
                        IF  INT space pos := 0;
                            NOT char in string( " ", space pos, pfx )
                        THEN
                            # the prefix is only one word                #
                            pfx := sfx
                        ELSE
                            # have multiple words                        #
                            pfx := ( pfx[ space pos + 1 : ] + " " + sfx )[ @ 1 ]
                        FI;
                        STRING pfx without punctuation = pfx REMOVE punctuation;
                        IF pfx without punctuation /= "" THEN pfx := pfx without punctuation FI
                    FI
                FI
            OD;
            print( ( line, newline ) )
        OD
    FI;
    close( input file )
FI
