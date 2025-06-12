BEGIN # Mad Libs style story generation                                      #

    # gets the story template from the file f. The template terminates with  #
    # a blank line                                                           #
    # The user is then promoted for the replacements for the <word> markers  #
    # and the story is printed with the substitutions made                   #
    PROC story = ( REF FILE f )VOID:
    BEGIN

        # a linked list of strings, used to hold the story template          #
        MODE STRINGLIST = STRUCT( STRING text, REF STRINGLIST next );

        # a linked list of pairs of strings, used to hold the replacements   #
        MODE REPLACEMENTLIST = STRUCT( STRING word
                                     , STRING replacement
                                     , REF REPLACEMENTLIST next
                                     );
        # NIL reference for marking the end of a STRINGLIST                  #
        REF STRINGLIST      nil stringlist      = NIL;
        # NIL reference for marking the end of a REPLACEMENTLIST             #
        REF REPLACEMENTLIST nil replacementlist = NIL;

        # returns "text" with trailing spaces removed                        #
        OP   RTRIM = ( STRING text )STRING:
             BEGIN
                INT trim pos := UPB text;
                FOR text pos FROM UPB text BY -1 TO LWB text WHILE text[ text pos ] = " "
                DO
                    trim pos := text pos - 1
                OD;
                text[ LWB text : trim pos ]
            END; # RTRIM #

        # looks for word in the dictionary. If it is found, replacement is   #
        # set to its replacement and TRUE is returned. If word not present,  #
        # FALSE is returned - uses recursion                                 #
        PROC find replacement = ( STRING word
                                , REF STRING replacement
                                , REF REPLACEMENTLIST story dictionary
                                ) BOOL:
             IF   story dictionary IS nil replacementlist
             THEN FALSE
             ELIF word OF story dictionary = word
             THEN replacement := replacement OF story dictionary;
                  TRUE
             ELSE find replacement( word, replacement, next OF story dictionary )
             FI; # find replacement #


        # read the story template                                            #

        # the result has a dummy element so "next OF next" is always valid   #
        REF STRINGLIST     story text := HEAP STRINGLIST := ( "dummy", nil stringlist );
        REF REF STRINGLIST next  := story text;

        WHILE # read the story template, terminates with a blank line        #
              STRING text;
              get( f, ( text, newline ) );
              text := RTRIM text;
              text /= ""
        DO
            # add the line to the end of the list #
            next := ( next OF next ) := HEAP STRINGLIST := ( text, nil stringlist )
        OD;

        # find the <word> markers in the story and replace them with the     #
        # user's chosen text - we ignore the dummy element at the start      #

        REF REPLACEMENTLIST dictionary := nil replacementlist;
        REF STRINGLIST      line       := story text;

        WHILE line := next OF line;
              line ISNT nil stringlist
        DO
            # have a line of text - replace all the <word> markers in it     #
            STRING word, replacement;
            INT start pos, end pos;
            WHILE char in string( "<", start pos, text OF line )
              AND char in string( ">", end pos,   text OF line )
            DO
                # have a marker, get it from the line                        #
                word := ( text OF line )[ start pos : end pos ];
                # get its replacement                                        #
                IF NOT find replacement( word, replacement, dictionary )
                THEN
                    # we don't already have a replacement for word           #
                    # get one from the user and add it to the dictionary     #
                    print( ( "What should replace ", word, "? " ) );
                    read( ( replacement, newline ) );
                    dictionary := HEAP REPLACEMENTLIST := ( word, replacement, dictionary )
                FI;
                # replace <word> with the replacement                        #
                text OF line := ( text OF line )[ : start pos - 1 ]
                              + replacement
                              + ( text OF line )[ end pos + 1 : ]
            OD
        OD;

        # print the story, ignoring the dummy element at the start           #

        line := story text;
        WHILE line := next OF line;
              line ISNT nil stringlist
        DO
            print( ( text OF line, newline ) )
        OD

    END; # story #

    # we read the template from stand in (the keyboard unless it's been  #
    # redirected) we could prompt the user for a template file name,     #
    # open it and read that instead...                                   #
    print( ( "Please Enter the story template terminated by a blank line", newline ) );
    story( stand in )

END
