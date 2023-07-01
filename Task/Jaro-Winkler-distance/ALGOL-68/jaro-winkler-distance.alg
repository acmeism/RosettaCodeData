PROC jaro sim = ( STRING sp1, sp2 )REAL:
     IF   STRING s1 = sp1[ AT 0 ];
          STRING s2 = sp2[ AT 0 ];
          INT le1   = ( UPB s1 - LWB s1 ) + 1;
          INT le2   = ( UPB s2 - LWB s2 ) + 1;
          le1 < 1 AND le2 < 1
     THEN # both strings are empty #         1
     ELIF le1 < 1 OR  le2 < 1
     THEN # one of the strings is empty #    0
     ELSE # both strings are non-empty #
        INT dist := IF le2 > le1 THEN le2 ELSE le1 FI;
        dist OVERAB 2 -:= 1;
        [ 0 : le1 ]BOOL matches1; FOR i FROM LWB matches1 TO UPB matches1 DO matches1[ i ] := FALSE OD;
        [ 0 : le2 ]BOOL matches2; FOR i FROM LWB matches2 TO UPB matches2 DO matches2[ i ] := FALSE OD;
        INT matches  := 0;
        INT transpos := 0;
        FOR i FROM LWB s1 TO UPB s1 DO
            INT start := i - dist;
            IF  start < 0 THEN start := 0 FI;
            INT end   := i + dist + 1;
            IF  end > le2 THEN end := le2 FI;
            FOR k FROM start TO end - 1
            WHILE IF matches2[ k ]
                  THEN TRUE
                  ELIF s1[ i ] /= s2[ k ]
                  THEN TRUE
                  ELSE
                      matches2[ k ] := matches1[ i ] := TRUE;
                      matches +:= 1;
                      FALSE
                  FI
            DO SKIP OD
        OD;
        IF matches = 0
        THEN 0
        ELSE
            INT k := 0;
            FOR i FROM LWB s1 TO UPB s1 DO
                IF matches1[ i ] THEN
                    WHILE NOT matches2[ k ] DO k +:= 1 OD;
                    IF s1[ i ] /= s2[ k ] THEN transpos +:= 1 FI;
                    k +:= 1
                FI
            OD;
            transpos OVERAB 2;
            ( ( matches / le1 )
            + ( matches / le2 )
            + ( ( matches - transpos ) / matches )
            ) / 3
        FI
     FI # jaro sim # ;
PROC jaro winkler dist = ( STRING sp, tp )REAL:
     BEGIN
        STRING s  = sp[ AT 0 ];
        STRING t  = tp[ AT 0 ];
        INT  ls = ( UPB s - LWB s ) + 1;
        INT  lt = ( UPB t - LWB t ) + 1;
        INT  l max := IF ls < lt THEN ls ELSE lt FI;
        IF   l max > 4 THEN l max := 4 FI;
        INT  l := 0;
        FOR  i FROM 0 TO l max - 1 DO IF s[ i ] = t[ i ] THEN l +:= 1 FI OD;
        REAL js = jaro sim( s, t );
        REAL p  = 0.1;
        REAL ws = js + ( l * p * ( 1 - js ) );
        1 - ws
     END # jaro winkler dist # ;
# include the Associative Array code #
PR read "aArray.a68" PR
# test cases #
[]STRING misspelt = ( "accomodate", "definately", "goverment", "occured", "publically", "recieve", "seperate", "untill", "wich" );
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
    WHILE NOT at eof
    DO
        STRING word;
        get( input file, ( word, newline ) );
        words // word := ""
    OD;
    # close the file #
    close( input file );
    # look for near matches to the misspelt words #
    INT max closest = 6; # max number of closest matches to show #
    FOR m pos FROM LWB misspelt TO UPB misspelt DO
        [ max closest ]STRING closest word;
        [ max closest ]REAL   closest jwd;
        FOR i TO max closest DO closest word[ i ] := ""; closest jwd[ i ] := 999 999 999 OD;
        REF AAELEMENT e := FIRST words;
        WHILE e ISNT nil element DO
            STRING word = key OF e;
            REAL jwd = jaro winkler dist( misspelt[ m pos ], word );
            BOOL found better match := FALSE;
            FOR i TO max closest WHILE NOT found better match DO
                IF jwd <= closest jwd[ i ] THEN
                    # found a new closer match #
                    found better match := TRUE;
                    # shuffle the others down 1 and insert the new match #
                    FOR j FROM max closest BY - 1 TO i + 1 DO
                        closest word[ j ] := closest word[ j - 1 ];
                        closest jwd[  j ] := closest jwd[  j - 1 ]
                    OD;
                    closest word[ i ] := word;
                    closest jwd[  i ] := jwd
                FI
            OD;
            e := NEXT words
        OD;
        print( ( "Misspelt word: ", misspelt[ m pos ], ":", newline ) );
        FOR i TO max closest DO
            print( ( fixed( closest jwd[ i ], -8, 4 ), " ", closest word[ i ], newline ) )
        OD;
        print( ( newline ) )
    OD
FI
