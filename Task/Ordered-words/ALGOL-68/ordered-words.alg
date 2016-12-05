# find the longrst words in a list that have all letters in order    #
# use the associative array in the Associate array/iteration task    #
PR read "aArray.a68" PR

# returns the length of word                                         #
PROC length = ( STRING word )INT: 1 + ( UPB word - LWB word );

# returns text with the characters sorted into ascending order       #
PROC char sort = ( STRING text )STRING:
     BEGIN
         STRING sorted := text;
         FOR end pos FROM UPB sorted - 1 BY -1 TO LWB sorted
         WHILE
             BOOL swapped := FALSE;
             FOR pos FROM LWB sorted TO end pos DO
                 IF sorted[ pos ] > sorted[ pos + 1 ]
                 THEN
                     CHAR  t           := sorted[ pos     ];
                     sorted[ pos     ] := sorted[ pos + 1 ];
                     sorted[ pos + 1 ] := t;
                     swapped           := TRUE
                 FI
             OD;
             swapped
         DO SKIP OD;
         sorted
    END # char sort # ;

# read the list of words and store the ordered ones in an associative array #

IF  FILE input file;
    STRING file name = "unixdict.txt";
    open( input file, file name, stand in channel ) /= 0
THEN
    # failed to open the file #
    print( (  "Unable to open """ + file name + """", newline ) )
ELSE
    # file opened OK #
    BOOL at eof := FALSE;
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
    # store the ordered words and find the longest #
    INT max length   := 0;
    REF AARRAY words := INIT LOC AARRAY;
    STRING word;
    WHILE NOT at eof
    DO
        STRING word;
        get( input file, ( word, newline ) );
        IF char sort( word ) = word
        THEN
            # have an ordered word #
            IF  INT word length := length( word );
                word length > max length
            THEN
                max length := word length
            FI;
            # store the word #
            words // word := ""
        FI
    OD;
    # close the file #
    close( input file );

    print( ( "Maximum length of ordered words: ", whole( max length, -4 ), newline ) );
    # show the ordered words with the maximum length #
    REF AAELEMENT e := FIRST words;
    WHILE e ISNT nil element DO
        IF  max length = length( key OF e )
        THEN
            print( ( key OF e, newline ) )
        FI;
        e := NEXT words
    OD
FI
