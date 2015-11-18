# determine whether we can spell words with a set of blocks                  #

# construct the list of blocks                                               #
[][]STRING blocks = ( ( "B", "O" ), ( "X", "K" ), ( "D", "Q" ), ( "C", "P" )
                    , ( "N", "A" ), ( "G", "T" ), ( "R", "E" ), ( "T", "G" )
                    , ( "Q", "D" ), ( "F", "S" ), ( "J", "W" ), ( "H", "U" )
                    , ( "V", "I" ), ( "A", "N" ), ( "O", "B" ), ( "E", "R" )
                    , ( "F", "S" ), ( "L", "Y" ), ( "P", "C" ), ( "Z", "M" )
                    );

# Returns TRUE if we can spell the word using the blocks, FALSE otherwise    #
# Returns TRUE for an empty string                                           #
PROC can spell = ( STRING word, [][]STRING blocks )BOOL:
    BEGIN

        # construct a set of flags to indicate whether the blocks are used   #
        # or not                                                             #
        [ 1 LWB blocks : 1 UPB blocks ]BOOL used;
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
            FOR block pos FROM 1 LWB blocks TO 1 UPB blocks
            WHILE NOT found
            DO
                IF  (  c = blocks[ block pos ][ 1 ][ 1 ]
                    OR c = blocks[ block pos ][ 2 ][ 1 ]
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


main: (

    # test the can spell procedure                                           #
    PROC test can spell = ( STRING word, [][]STRING blocks )VOID:
        write( ( ( "can spell: """
                 + word
                 + """ -> "
                 + IF can spell( word, blocks ) THEN "yes" ELSE "no" FI
                 )
               , newline
               )
             );

    test can spell( "A",       blocks );
    test can spell( "BaRK",    blocks );
    test can spell( "BOOK",    blocks );
    test can spell( "TREAT",   blocks );
    test can spell( "COMMON",  blocks );
    test can spell( "SQUAD",   blocks );
    test can spell( "CONFUSE", blocks )

)
