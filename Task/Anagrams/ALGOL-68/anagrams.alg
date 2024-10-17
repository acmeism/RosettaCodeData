# find longest list(s) of words that are anagrams in a list of words #
# use the associative array in the Associate array/iteration task    #
PR read "aArray.a68" PR

# returns the number of occurances of ch in text #
PROC count = ( STRING text, CHAR ch )INT:
     BEGIN
         INT result := 0;
         FOR c FROM LWB text TO UPB text DO IF text[ c ] = ch THEN result +:= 1 FI OD;
         result
     END # count # ;

# returns text with the characters sorted into ascending order #
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

# read the list of words and store in an associative array           #

CHAR separator = "|"; # character that will separate the anagrams #

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
    REF AARRAY words := INIT LOC AARRAY;
    WHILE NOT at eof
    DO
        STRING word;
        get( input file, ( word, newline ) );
        words // char sort( word ) +:= separator + word
    OD;
    # close the file #
    close( input file );

    # find the maximum number of anagrams #

    INT max anagrams := 0;

    REF AAELEMENT e := FIRST words;
    WHILE e ISNT nil element DO
        IF  INT anagrams := count( value OF e, separator );
            anagrams > max anagrams
        THEN
            max anagrams := anagrams
        FI;
        e := NEXT words
    OD;

    print( ( "Maximum number of anagrams: ", whole( max anagrams, -4 ), newline ) );
    # show the anagrams with the maximum number #
    e := FIRST words;
    WHILE e ISNT nil element DO
        IF  INT anagrams := count( value OF e, separator );
            anagrams = max anagrams
        THEN
            print( ( ( value OF e )[ ( LWB value OF e ) + 1: ], newline ) )
        FI;
        e := NEXT words
    OD
FI
