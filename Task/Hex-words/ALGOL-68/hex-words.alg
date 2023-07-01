# find words that contain only hex digits a-f #
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
    INT count := 0;
    INT max words = 100; # guess at the maximum number of words #
    MODE HEXWORD = STRUCT( STRING word, LONG INT value, INT root, INT len );
    [ 1 : max words ]HEXWORD hw;
    WHILE STRING word;
          get( input file, ( word, newline ) );
          NOT at eof
    DO
        # check the word contains only a-f and compute its decimal value #
        IF  INT word len = ( UPB word + 1 ) - LWB word;
            word len >= 4
        THEN
            # the word is at least 4 characters long #
            BOOL is hex word := word /= "";
            LONG INT  int word    := 0;
            FOR i FROM LWB word TO UPB word
            WHILE is hex word := word[ i ] >= "a" AND word[ i ] <= "f"
            DO
                int word *:= 16;
                int word +:= ( ABS word[ i ] - ABS "a" ) + 10
            OD;
            IF is hex word
            THEN
                # have a hex word #
                count +:= 1;
                # compute the digital root #
                LONG INT r := int word;
                WHILE r > 9 DO
                    LONG INT dr := r MOD 10;
                    WHILE ( r OVERAB 10 ) > 0 DO dr +:= r MOD 10 OD;
                    r := dr
                OD;
                word  OF hw[ count ] := word;
                value OF hw[ count ] := int word;
                root  OF hw[ count ] := SHORTEN r;
                len   OF hw[ count ] := word len
            FI
        FI
    OD;
    close( input file );
    # prints the HEXWORD hw #
    PROC show = ( HEXWORD hw )VOID:
    BEGIN
        STRING pad = IF len OF hw >= 12 THEN "" ELSE ( 12 - len OF hw ) * " " FI;
        print( ( word OF hw, ": ", pad, whole( value OF hw, -10 ), " [ ", whole( root OF hw, 0 ), " ]", newline ) )
    END # show # ;
    # Quicksorts in-place the array of HEXWORDS a, from lb to ub on ascending value #
    PROC quicksort = ( REF[]HEXWORD a, INT lb, ub )VOID:
         IF ub > lb THEN
            # more than one element, so must sort #
            INT left   := lb;
            INT right  := ub;
            # choosing the middle element of the array as the pivot #
            LONG INT pivot  := value OF a[ left + ( ( right + 1 ) - left ) OVER 2 ];
            WHILE
                WHILE IF left  <= ub THEN value OF a[ left  ] < pivot ELSE FALSE FI DO left  +:= 1 OD;
                WHILE IF right >= lb THEN value OF a[ right ] > pivot ELSE FALSE FI DO right -:= 1 OD;
                left <= right
            DO
                HEXWORD t  := a[ left  ];
                a[ left  ] := a[ right ];
                a[ right ] := t;
                left      +:= 1;
                right     -:= 1
            OD;
            quicksort( a, lb,   right );
            quicksort( a, left, ub    )
         FI # quicksort # ;
    # show the hex words in ascending order of digital root #
    FOR r FROM 1 TO 9 DO
        FOR i FROM 1 TO count DO
            IF root OF hw[ i ] = r THEN show( hw[ i ] ) FI
        OD
    OD;
    print( ( "Found ", whole( count, 0 ), " hex words", newline, newline ) );
    # show the words in descending value order excluding those with less than 4 unique letters #
    quicksort( hw, 1, count );
    INT count 4 := 0;
    FOR i FROM count BY -1 TO 1 DO
        # check the word has at least four different digits #
        INT a := 0, b := 0, c := 0, d := 0, e := 0, f := 0;
        FOR c pos FROM LWB word OF hw[ i ] TO UPB word OF hw[ i ] DO
            IF   CHAR ch = ( word OF hw[ i ] )[ c pos ];
                 ch = "a"
            THEN a := 1
            ELIF ch = "b"
            THEN b := 1
            ELIF ch = "c"
            THEN c := 1
            ELIF ch = "d"
            THEN d := 1
            ELIF ch = "e"
            THEN e := 1
            ELSE f := 1
            FI
        OD;
        IF a + b + c + d + e + f >= 4
        THEN
            # have a hex word with at least 4 different digits #
            count 4 +:= 1;
            show( hw[ i ] )
        FI
    OD;
    print( ( "Found ", whole( count 4, 0 ), " hex words with 4 or more distinct digits", newline ) )
FI
