# ABC problem:                                                               #
# determine whether we can spell words with a set of blocks                  #

# Returns TRUE if we can spell the word using the blocks, FALSE otherwise    #
# Returns TRUE for an empty string                                           #
PROC can spell = ( STRING word, [][]STRING block set )BOOL:
    BEGIN

        # construct a set of flags to indicate whether the blocks are used   #
        # or not                                                             #
        [ 1 LWB block set : 1 UPB block set ]BOOL used;
        FOR block pos FROM LWB used TO UPB used
        DO
            used[ block pos ] := FALSE
        OD;

        # initialliy assume we can spell the word                            #
        BOOL result := TRUE;

        # check we can spell the word with the set of blocks                 #
        FOR word pos FROM LWB word TO UPB word WHILE result
        DO
            CHAR c = IF   is lower( word[ word pos ] )
                     THEN to upper( word[ word pos ] )
                     ELSE           word[ word pos ]
                     FI;

            # look through the unused blocks for the current letter          #
            BOOL found := FALSE;
            FOR block pos FROM 1 LWB block set TO 1 UPB block set
            WHILE NOT found
            DO
                IF  (  c = block set[ block pos ][ 1 ][ 1 ]
                    OR c = block set[ block pos ][ 2 ][ 1 ]
                    )
                AND NOT used[ block pos ]
                THEN
                    # found an unused block with the required letter         #
                    found             := TRUE;
                    used[ block pos ] := TRUE
                FI
            OD;

            result := found

        OD;

        result
    END; # can spell #


# main # (

    [][]STRING abc blocks # construct the list of blocks                     #
                  = ( ( "B", "O" ), ( "X", "K" ), ( "D", "Q" ), ( "C", "P" )
                    , ( "N", "A" ), ( "G", "T" ), ( "R", "E" ), ( "T", "G" )
                    , ( "Q", "D" ), ( "F", "S" ), ( "J", "W" ), ( "H", "U" )
                    , ( "V", "I" ), ( "A", "N" ), ( "O", "B" ), ( "E", "R" )
                    , ( "F", "S" ), ( "L", "Y" ), ( "P", "C" ), ( "Z", "M" )
                    );

    # test the can spell procedure                                           #
    PROC test can spell = ( STRING word, [][]STRING block set )VOID:
        write( ( ( "can spell: """
                 + word
                 + """ -> "
                 + IF can spell( word, block set ) THEN "yes" ELSE "no" FI
                 )
               , newline
               )
             );

    test can spell( "A",       abc blocks );
    test can spell( "BaRK",    abc blocks );
    test can spell( "BOOK",    abc blocks );
    test can spell( "TREAT",   abc blocks );
    test can spell( "COMMON",  abc blocks );
    test can spell( "SQUAD",   abc blocks );
    test can spell( "CONFUSE", abc blocks )

)
