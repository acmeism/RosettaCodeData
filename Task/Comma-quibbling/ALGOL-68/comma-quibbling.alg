# returns a string ( assumed to be of space-separated words ) with the words  #
# separated by ", ", except for the last which is separated from the rest by  #
# " and ". The list is enclosed by braces                                     #
PROC to list = ( STRING words ) STRING:
    BEGIN
        # count the number of words                                           #
        INT  word count := 0;
        BOOL in word    := FALSE;
        FOR char pos FROM LWB words TO UPB words
        DO
            IF NOT is upper( words[ char pos ] )
            THEN
                # not an upper-case letter, possibly a word has been ended    #
                in word := FALSE
            ELSE
                # not a delimitor, possibly the start of a word               #
                IF NOT in word
                THEN
                    # we are starting a new word                              #
                    word count +:= 1;
                    in word     := TRUE
                FI
            FI
        OD;

        # format the result                                                   #
        STRING result    := "{";
        in word          := FALSE;
        INT  word number := 0;
        FOR char pos FROM LWB words TO UPB words
        DO
            IF NOT is upper( words[ char pos ] )
            THEN
                # not an upper-case letter, possibly a word has been ended    #
                in word := FALSE
            ELSE
                # not a delimitor, possibly the start of a word               #
                IF NOT in word
                THEN
                    # we are starting a new word                              #
                    word number +:= 1;
                    in word      := TRUE;
                    IF word number > 1
                    THEN
                        # second or subsequent word - need a separator        #
                        result +:= IF word number = word count
                                   THEN # final word                          #
                                       " and "
                                   ELSE # non-final word                      #
                                       ", "
                                   FI
                    FI
                FI;
                # add the character to the result                             #
                result +:= words[ char pos ]
            FI
        OD;

        result + "}"
    END # to list # ;


    # procedure to test the to list PROC                                      #
    PROC test to list = ( STRING words ) VOID:
        print( ( ( words
                 + ": "
                 + to list( words )
                 )
               , newline
               )
             );

    # test the to list PROC                                                   #
    test to list( "" );
    test to list( "ABC" );
    test to list( "ABC DEF" );
    test to list( "ABC DEF G H" )
