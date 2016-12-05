# find the semordnilaps in a list of words                           #
# use the associative array in the Associate array/iteration task    #
PR read "aArray.a68" PR

# returns text with the characters reversed                          #
OP REVERSE = ( STRING text )STRING:
     BEGIN
         STRING reversed  := text;
         INT    start pos := LWB text;
         FOR end pos FROM UPB reversed BY -1 TO LWB reversed
         DO
             reversed[ end pos ] := text[ start pos ];
             start pos +:= 1
         OD;
         reversed
    END # REVERSE # ;

# read the list of words and store the words in an associative array #
# check for semordnilaps                                             #
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
    STRING word;
    INT    semordnilap count := 0;
    WHILE NOT at eof
    DO
        STRING word;
        get( input file, ( word, newline ) );
        STRING reversed word = REVERSE word;
        IF ( words // reversed word ) = ""
        THEN
            # the reversed word isn't in the array                   #
            words // word := reversed word
        ELSE
            # we already have this reversed - we have a semordnilap  #
            semordnilap count +:= 1;
            IF semordnilap count <= 5
            THEN
                print( ( reversed word, " & ", word, newline ) )
           FI
        FI
    OD;
    close( input file );
    print( ( whole( semordnilap count, 0 ), " semordnilaps found", newline ) )
FI
