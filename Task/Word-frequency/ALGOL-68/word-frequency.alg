# find the n most common words in a file                             #
# use the associative array in the Associate array/iteration task    #
# but with integer values                                            #
PR read "aArrayBase.a68" PR
MODE AAKEY   = STRING;
MODE AAVALUE = INT;
AAVALUE init element value = 0;
# returns text converted to upper case                                 #
OP   TOUPPER  = ( STRING text )STRING:
     BEGIN
        STRING result := text;
        FOR ch pos FROM LWB result TO UPB result DO
            IF is lower( result[ ch pos ] ) THEN result[ ch pos ] := to upper( result[ ch pos ] ) FI
        OD;
        result
     END # TOUPPER # ;
# returns text converted to an INT or -1 if text is not a number     #
OP   TOINT    = ( STRING text )INT:
     BEGIN
        INT  result     := 0;
        BOOL is numeric := TRUE;
        FOR ch pos FROM UPB text BY -1 TO LWB text WHILE is numeric DO
            CHAR c = text[ ch pos ];
            is numeric := is numeric AND c >= "0" AND c <= "9";
            IF is numeric THEN ( result *:= 10 ) +:= ABS c - ABS "0" FI
        OD;
        IF is numeric THEN result ELSE -1 FI
     END # TOINT # ;
# returns TRUE if c is a letter, FALSE otherwise                     #
OP   ISLETTER    = ( CHAR c )BOOL:
        IF ( c >= "a" AND c <= "z" )
        OR ( c >= "A" AND c <= "Z" )
        THEN TRUE
        ELSE char in string( c, NIL, "ÇåçêëÆôöÿÖØáóÔ" )
        FI # ISLETER # ;
# get the file name and number of words from then commmand line      #
STRING file name       := "pg-les-misrables.txt";
INT    number of words := 10;
FOR arg pos TO argc - 1 DO
    STRING arg upper = TOUPPER argv( arg pos );
    IF   arg upper = "FILE"   THEN
        file name := argv( arg pos + 1 )
    ELIF arg upper  = "NUMBER" THEN
        number of words := TOINT argv( arg pos + 1 )
    FI
OD;
IF  FILE input file;
    open( input file, file name, stand in channel ) /= 0
THEN
    # failed to open the file #
    print( ( "Unable to open """ + file name + """", newline ) )
ELSE
    # file opened OK #
    print( ( "Processing: ", file name, newline ) );
    BOOL at eof := FALSE;
    BOOL at eol := FALSE;
    # set the EOF handler for the file #
    on logical file end( input file, ( REF FILE f )BOOL:
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
    # get the words from the file and store the counts in an associative array #
    REF AARRAY words := INIT LOC AARRAY;
    INT word count := 0;
    CHAR c := " ";
    WHILE get( input file, ( c ) );
          NOT at eof
    DO
        WHILE NOT ISLETTER c AND NOT at eof DO get( input file, ( c ) ) OD;
        STRING word := "";
        at eol      := FALSE;
        WHILE ISLETTER c AND NOT at eol AND NOT at eof DO word +:= c; get( input file, ( c ) ) OD;
        word count +:= 1;
        words // TOUPPER word +:= 1
    OD;
    close( input file );
    print( ( file name, " contains ", whole( word count, 0 ), " words", newline ) );
    # find the most used words                                       #
    [ number of words ]STRING top words;
    [ number of words ]INT    top counts;
    FOR i TO number of words DO top words[ i ] := ""; top counts[ i ] := 0 OD;
    REF AAELEMENT w := FIRST words;
    WHILE w ISNT nil element DO
        INT    count  = value OF w;
        STRING word   = key   OF w;
        BOOL   found := FALSE;
        FOR i TO number of words WHILE NOT found DO
            IF count > top counts[ i ] THEN
                # found a word that is used nore than a current      #
                # most used word                                     #
                found := TRUE;
                # move the other words down one place                #
                FOR move pos FROM number of words BY - 1 TO i + 1 DO
                    top counts[ move pos ] := top counts[ move pos - 1 ];
                    top words [ move pos ] := top words [ move pos - 1 ]
                OD;
                # install the new word                               #
                top counts[ i ] := count;
                top words [ i ] := word
            FI
        OD;
        w := NEXT words
    OD;
    print( ( whole( number of words, 0 ), " most used words:", newline ) );
    print( ( " count  word", newline ) );
    FOR i TO number of words DO
        print( ( whole( top counts[ i ], -6 ), ": ", top words[ i ], newline ) )
    OD
FI
