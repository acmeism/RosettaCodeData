BEGIN # Simulate dynamic variables using an array, translation of the FreeBASIC sample #

    MODE DYNAMICVARIABLE = STRUCT( STRING name, value );

    OP   LCASE = ( CHAR c )CHAR: IF c >= "A" AND c <= "Z" THEN REPR( ( ABS c - ABS "A" ) + ABS "a" ) ELSE c FI;
    OP   LCASE = ( STRING s )STRING:
         BEGIN
             STRING lc := s;
             FOR i FROM LWB lc TO UPB lc DO lc[ i ] := LCASE lc[ i ] OD;
             lc
         END # LCASE # ;
    OP   TRIM = ( STRING s )STRING:
         BEGIN
             INT left := LWB s, right := UPB s;
             WHILE IF left  > right THEN FALSE ELSE s[ left  ] = " " FI DO left  +:= 1 OD;
             WHILE IF right < left  THEN FALSE ELSE s[ right ] = " " FI DO right -:= 1 OD;
             s[ left : right ]
         END # TRIM # ;

    PROC find variable index = ( []DYNAMICVARIABLE a, STRING v, INT n elements )INT:
         BEGIN
            STRING name   = LCASE TRIM v;
            INT index    := LWB a - 1;
            INT max index = index + n elements;
            FOR i FROM LWB a TO max index WHILE index < LWB a DO
                IF name OF a[ i ] = name THEN index := i FI
            OD;
            index
         END # find variable index # ;

    INT n;
    WHILE
        print( ( "How many variables do you want to create (max 5) " ) );
        read( ( n, newline ) );
        n < 0 OR n > 5
    DO SKIP OD;

    [ 1 : n ]DYNAMICVARIABLE a;

    print( ( newline, "OK, enter the variable names and their values, below", newline ) );

    FOR i TO n DO
        WHILE
            print( ( "  Variable ", whole( i, 0 ), newline ) );
            print( ( "    Name  : " ) );
            read( ( name OF a[ i ], newline ) );
            name OF a[ i ] := LCASE TRIM name OF a[ i ];
            # identifiers should not be case-sensitive in Algol 68 though #
            # in upper stropped sources (such as this one) they have to   #
            # be in lower case                                            #
            find variable index( a, name OF a[ i ], i - 1 ) > 0
        DO
            print( ( "  Sorry, you've already created a variable of that name, try again", newline ) )
        OD;
        print( ( "    Value : " ) );
        read( ( value OF a[ i ], newline ) );
        value OF a[ i ] := TRIM value OF a[ i ]
    OD;

    print( ( newline, "Press q to quit" ) );
    WHILE
        STRING v;
        print( ( newline, "Which variable do you want to inspect ? " ) );
        read( ( v, newline ) );
        v /= "q" AND v /= "Q"
    DO
        IF  INT index = find variable index( a, v, n );
            index = 0
        THEN
            print( ( "Sorry there's no variable of that name, try again", newline ) )
        ELSE
            print( ( "It's value is ", value OF a[ index ], newline ) )
        FI
    OD

END
