BEGIN # convert camel case to and from snake case #
    # returns c converted to uppercase if it is lowercase, c otherwise #
    OP   TOUPPER = ( CHAR c )STRING:
         IF c >= "a" AND c <= "z" THEN REPR( ( ABS c - ABS "a" ) + ABS "A" ) ELSE c FI;
    # returns c converted to lowercase if it is uppercase, c otherwise #
    OP   TOLOWER = ( CHAR c )STRING:
         IF c >= "A" AND c <= "Z" THEN REPR( ( ABS c - ABS "A" ) + ABS "a" ) ELSE c FI;
    # returns the camel case identifier c in snake case #
    OP   CAMELTOSNAKE = ( STRING c )STRING: c CAMELTOBREAK "_";
    # returns the camel case identifier c in kebab case #
    OP   CAMELTOKEBAB = ( STRING c )STRING: c CAMELTOBREAK "-";
    # returns TRUE if c is a "break" character ( " ", "-" or "_" ), FALSE otherwise #
    OP   ISBREAK = ( CHAR c )BOOL: c = " " OR c = "-" OR c = "_";
    # returns the indentifier id (which is assumed to be in Camel case) #
    #         converted to snake or kebab case depending on break char #
    PRIO CAMELTOBREAK = 9; # CAMELTOBREAK is dyadic so need a priority #
    OP   CAMELTOBREAK = ( STRING id, CHAR break char )STRING:
         BEGIN
            STRING result := "";
            STRING orig    = TRIM id; # remove leading and trailing spaces #
            BOOL   first  := TRUE;
            INT    c pos  := LWB orig;
            WHILE c pos <= UPB orig DO
                CHAR c = orig[ c pos ];
                IF c >= "A" AND c <= "Z" THEN
                    # have an uppercase letter #
                    IF NOT first THEN result +:= break char FI;
                    result +:= TOLOWER c
                ELIF ISBREAK c THEN
                    # replace one or more spaces and break characters by a single break #
                    BOOL have break := TRUE;
                    WHILE c pos <= UPB orig AND have break DO
                        IF have break := ISBREAK orig[ c pos ] THEN c pos +:= 1 FI
                    OD;
                    IF c pos <= UPB orig THEN
                        # the identifier didn't end wih a break #
                        result +:= break char + TOLOWER orig[ c pos ]
                    FI
                ELSE
                    # lowercase or punctuation #
                    result +:= c
                FI;
                first  := FALSE;
                c pos +:= 1
            OD;
            result
         END # CAMELTOBREAK # ;
    # returns the identifier id ( which is assumed to be in snake/kebab/space case ) #
    #         converted to Camel case #
    OP   TOCAMEL = ( STRING id )STRING:
         BEGIN
            STRING result := "";
            STRING orig    = TRIM id; # remove leading and trailing spaces #
            INT    c pos  := LWB orig;
            WHILE  c pos <= UPB orig DO
                CHAR c = orig[ c pos ];
                IF c >= "A" AND c <= "Z" THEN
                    # uppercase letter - leave as is #
                    result +:= c
                ELIF NOT ISBREAK c THEN
                    # not a break - convert to lower case if necessary and move to the next #
                    result +:= TOLOWER c;
                ELSE
                    # have a separator - skip all subsequent separators and upcase the follower #
                    BOOL have break := TRUE;
                    WHILE c pos <= UPB orig AND have break DO
                        IF have break := ISBREAK orig[ c pos ] THEN c pos +:= 1 FI
                    OD;
                    IF c pos <= UPB orig THEN
                        # the identifier didn't end with a break character #
                        result +:= TOUPPER orig[ c pos ]
                    FI
                FI;
                c pos +:= 1
            OD;
            result
         END # TOCAMEL # ;
    # returns s left-padded to len characters or s if s is already that long #
    PRIO PAD = 9;
    OP   PAD = ( INT len, STRING s )STRING:
         IF    INT s len = ( UPB s - LWB s ) + 1;
               s len >= len
         THEN s
         ELSE
             STRING result := s;
             FOR i FROM s len + 1 TO len DO " " +=: result OD;
             result
         FI # PAD # ;
    # returns s with leading and trailing spaces removed #
    OP   TRIM = ( STRING s )STRING:
         BEGIN
             INT left  := LWB s;
             INT right := UPB s;
             WHILE IF left  > right THEN FALSE ELSE s[ left  ] = " " FI DO left  +:= 1 OD;
             WHILE IF right < left  THEN FALSE ELSE s[ right ] = " " FI DO right -:= 1 OD;
             s[ left : right ]
         END # TRIM # ;
    # task test cases #
    []STRING identifier = ( "snakeCase", "snake_case", "variable_10_case", "variable10Case", "ɛrgo rE tHis"
                          , "hurry-up-joe!", "c://my-docs/happy_Flag-Day/12.doc", "  spaces  "
                          );
    print( ( "to snake case:", newline ) );
    FOR i FROM LWB identifier TO UPB identifier DO
        print( ( 40 PAD identifier[ i ], " -> ", CAMELTOSNAKE identifier[ i ], newline ) )
    OD;
    print( ( "to Camel case:", newline ) );
    FOR i FROM LWB identifier TO UPB identifier DO
        print( ( 40 PAD identifier[ i ], " -> ",      TOCAMEL identifier[ i ], newline ) )
    OD;
    print( ( "to kebab case:", newline ) );
    FOR i FROM LWB identifier TO UPB identifier DO
        print( ( 40 PAD identifier[ i ], " -> ", CAMELTOKEBAB identifier[ i ], newline ) )
    OD
END
