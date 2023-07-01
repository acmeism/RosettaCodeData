# find textonyms in a list of words #
# use the associative array in the Associate array/iteration task     #
PR read "aArray.a68" PR

# returns the number of occurances of ch in text #
PROC count = ( STRING text, CHAR ch )INT:
     BEGIN
         INT result := 0;
         FOR c FROM LWB text TO UPB text DO IF text[ c ] = ch THEN result +:= 1 FI OD;
         result
     END # count # ;

CHAR invalid char = "*";

# returns text with the characters replaced by their text digits      #
PROC to text = ( STRING text )STRING:
     BEGIN
         STRING result := text;
         FOR pos FROM LWB result TO UPB result DO
             CHAR c = to upper( result[ pos ] );
             IF   c = "A" OR c = "B" OR c = "C"            THEN result[ pos ] := "2"
             ELIF c = "D" OR c = "E" OR c = "F"            THEN result[ pos ] := "3"
             ELIF c = "G" OR c = "H" OR c = "I"            THEN result[ pos ] := "4"
             ELIF c = "J" OR c = "K" OR c = "L"            THEN result[ pos ] := "5"
             ELIF c = "M" OR c = "N" OR c = "O"            THEN result[ pos ] := "6"
             ELIF c = "P" OR c = "Q" OR c = "R" OR c = "S" THEN result[ pos ] := "7"
             ELIF c = "T" OR c = "U" OR c = "V"            THEN result[ pos ] := "8"
             ELIF c = "W" OR c = "X" OR c = "Y" OR c = "Z" THEN result[ pos ] := "9"
             ELSE # not a character that can be encoded #       result[ pos ] := invalid char
             FI
         OD;
         result
     END # to text # ;

# read the list of words and store in an associative array           #

CHAR separator = "/"; # character that will separate the textonyms   #

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
    REF AARRAY words   := INIT LOC AARRAY;
    INT word count     := 0;
    INT combinations   := 0;
    INT multiple count := 0;
    INT max length     := 0;
    WHILE STRING word;
          get( input file, ( word, newline ) );
          NOT at eof
    DO
        STRING text word = to text( word );
        IF count( text word, invalid char ) = 0 THEN
            # the word can be fully encoded #
            word count +:= 1;
            INT length := ( UPB word - LWB word ) + 1;
            IF length > max length THEN
                # this word is longer than the maximum length found so far #
                max length := length
            FI;
            IF ( words // text word ) = "" THEN
                # first occurance of this encoding #
                combinations +:= 1;
                words // text word := word
            ELSE
                # this encoding has already been used #
                IF count( words // text word, separator ) = 0
                THEN
                    # this is the second time this encoding is used #
                    multiple count +:= 1
                FI;
                words // text word +:= separator + word
            FI
        FI
    OD;
    # close the file #
    close( input file );

    # find the maximum number of textonyms #

    INT max textonyms := 0;

    REF AAELEMENT e := FIRST words;
    WHILE e ISNT nil element DO
        INT textonyms := count( value OF e, separator );
        IF  textonyms > max textonyms
        THEN
            max textonyms := textonyms
        FI;
        e := NEXT words
    OD;

    print( ( "There are ", whole( word count, 0 ), " words in ", file name, " which can be represented by the digit key mapping.", newline ) );
    print( ( "They require ", whole( combinations, 0 ), " digit combinations to represent them.", newline ) );
    print( ( whole( multiple count, 0 ), " combinations represent Textonyms.", newline ) );

    # show the textonyms with the maximum number #
    print( ( "The maximum number of textonyms for a particular digit key mapping is ", whole( max textonyms + 1, 0 ), " as follows:", newline ) );
    e := FIRST words;
    WHILE e ISNT nil element DO
        IF  INT textonyms := count( value OF e, separator );
            textonyms = max textonyms
        THEN
            print( ( "    ", key OF e, " encodes ", value OF e, newline ) )
        FI;
        e := NEXT words
    OD;

    # show the textonyms with the maximum length #
    print( ( "The longest words are ", whole( max length, 0 ), " chracters long", newline ) );
    print( ( "Encodings with this length are:", newline ) );
    e := FIRST words;
    WHILE e ISNT nil element DO
        IF max length = ( UPB key OF e - LWB key OF e ) + 1
        THEN
            print( ( "    ", key OF e, " encodes ", value OF e, newline ) )
        FI;
        e := NEXT words
    OD;

FI
