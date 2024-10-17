# find the largest deranged anagrams in a list of words              #
# use the associative array in the Associate array/iteration task    #
PR read "aArray.a68" PR

# returns the length of str                                          #
OP LENGTH = ( STRING str )INT: 1 + ( UPB str - LWB str );

# returns TRUE if a and b are the same length and have no            #
# identical characters at any position,                              #
# FALSE otherwise                                                    #
PRIO ALLDIFFER = 9;
OP   ALLDIFFER = ( STRING a, b )BOOL:
     IF LENGTH a /= LENGTH b
     THEN
        # the two stringa are not the same size                      #
        FALSE
     ELSE
        # the strings are the same length, check the characters      #
        BOOL result := TRUE;
        INT  b pos  := LWB b;
        FOR a pos FROM LWB a TO UPB a WHILE result := ( a[ a pos ] /= b[ b pos ] )
        DO
            b pos +:= 1
        OD;
        result
     FI # ALLDIFFER # ;

# returns text with the characters sorted                            #
OP   SORT = ( STRING text )STRING:
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
     END # SORTED # ;

# read the list of words and find the longest deranged anagrams      #

CHAR separator = "|"; # character that will separate the anagrams    #

IF  FILE input file;
    STRING file name = "unixdict.txt";
    open( input file, file name, stand in channel ) /= 0
THEN
    # failed to open the file #
    print( ( "Unable to open """ + file name + """", newline ) )
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
    INT    longest derangement := 0;
    STRING longest word        := "<none>";
    STRING longest anagram     := "<none>";
    WHILE NOT at eof
    DO
        STRING word;
        get( input file, ( word, newline ) );
        INT    word length = LENGTH word;
        IF  word length >= longest derangement
        THEN
            # this word is at least long as the longest derangement   #
            # found so far - test it                                  #
            STRING sorted word = SORT word;
            IF ( words // sorted word ) /= ""
            THEN
                # we already have this sorted word - test for         #
                # deranged anagrams                                   #
                # the word list will have a leading separator         #
                # and be followed by one or more words separated by   #
                # the separator                                       #
                STRING word list   := words // sorted word;
                INT    list pos    := LWB word list + 1;
                INT    list max     = UPB word list;
                BOOL   is deranged := FALSE;
                WHILE  list pos < list max
                  AND  NOT is deranged
                DO
                    STRING anagram = word list[ list pos : ( list pos + word length ) - 1 ];
                    IF  is deranged := word ALLDIFFER anagram
                    THEN
                        # have a deranged anagram                     #
                        longest derangement := word length;
                        longest word        := word;
                        longest anagram     := anagram
                    FI;
                    list pos +:= word length + 1
                OD
            FI;
            # add the word to the anagram list                        #
            words // sorted word +:= separator + word
        FI
    OD;
    close( input file );
    print( ( "Longest deranged anagrams: "
           , longest word
           , " and "
           , longest anagram
           , newline
           )
         )
FI
