BEGIN # split text into n-grams - n character substrings                     #

    MODE NGRAM = STRUCT( STRING gram, INT count );

    OP   UCASE = ( CHAR c )CHAR:          # return c converted to upper case #
         IF c >= "a" AND c <= "z" THEN REPR( ( ABS c - ABS "a" ) + ABS "A" ) ELSE c FI;
    OP   UCASE = ( STRING s )STRING:      # return s converted to upper case #
         BEGIN
             STRING uc := s;
             FOR i FROM LWB uc TO UPB uc DO uc[ i ] := UCASE uc[ i ] OD;
             uc
         END # UCASE # ;
    OP   LENGTH = ( STRING s )INT: ( UPB s + 1 ) - LWB s;

    # returns the n-grams of text - using a simple array to contain the      #
    # n-grams - for longer strings, an associative array might be better     #
    PRIO GRAMS = 1;
    OP   GRAMS = ( INT n, STRING text )[]NGRAM:
         BEGIN
            [ 1 : ( LENGTH text + 1 ) - n ]NGRAM result;  # initially assume #
            INT count := 0;                 # all the n-grams will be unique #
            FOR pos FROM LWB text TO ( UPB text + 1 )- n DO
                STRING ng     = UCASE text[ pos : pos + ( n - 1 ) ];
                BOOL   found := FALSE;
                INT    g pos := 0;
                FOR g FROM 1 TO count
                WHILE g pos := g;
                      NOT ( found := ng = ( gram OF result )[ g ] )
                DO SKIP OD;
                IF NOT found THEN
                    result[ count +:= 1 ] := ( ng, 1 )
                ELSE
                    ( count OF result )[ g pos ] +:= 1
                FI
            OD;
            result[ 1 : count ]
         END # NGRAMS # ;

    # prints the ngrams in ngrams                                           #
    PROC print ngrams = ( STRING title, text, []NGRAM ngrams )VOID:
         BEGIN
            print( ( title, "-grams of """, text, """:", newline ) );
            FOR g FROM LWB ngrams TO UPB ngrams DO
                print( ( "    """, ( gram OF ngrams )[ g ] ) );
                print( ( """: ", whole( ( count OF ngrams )[ g ], 0 ), newline ) )
            OD
         END # print ngrams # ;

    STRING  test       = "Live and let live";
    print ngrams( "bi",   test, 2 GRAMS test );
    print ngrams( "tri",  test, 3 GRAMS test );
    print ngrams( "quad", test, 4 GRAMS test )

END
