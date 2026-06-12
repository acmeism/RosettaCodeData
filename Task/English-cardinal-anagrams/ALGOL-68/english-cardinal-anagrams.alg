BEGIN # construct number names from a number                                  #
    PR read "sort.incl.a68" PR                       # include sort utilities #
    MODE NUMBER = LONG INT;        # adjust to suit, must be at least 64 bits #
    OP TOINT = ( NUMBER n )INT: SHORTEN n;                   # adjust to suit #
    []STRING units
           = ( "one", "two",  "three", "four", "five", "six", "seven", "eight", "nine" );
    []STRING teens
           = ( "ten",     "eleven",  "twelve",    "thirteen", "fourteen"
             , "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"
             );
    []STRING tens
           = ( "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety" );
    []STRING power suffix
           = ( "thousand", "million", "billion", "trillion", "quadrillion", "quintillion" );
    # returns c encoded as a = 1, b = 2, etc. c must be in "a".."z"           #
    OP LETTER = ( CHAR c )INT: ( ABS c - ABS "a" ) + 1;
    # returns n converted to a number name, n must be in range 1-99           #
    PROC two digits = ( INT n )STRING:
         IF   n < 10
         THEN units[ n ]
         ELIF n < 20
         THEN teens[ n - 9 ]
         ELIF INT last1 = n MOD 10;
              last1 = 0
         THEN tens[ ( n OVER 10 ) - 1 ]
         ELSE tens[ ( n OVER 10 ) - 1 ] + " " + units[ last1 ]
         FI # two digits # ;
    # returns n converted to a number name, n must be in range 1-999          #
    PROC three digits = ( INT n )STRING:
         IF   n < 100
         THEN two digits( n )
         ELIF STRING hundreds = units[ n OVER 100 ] + " hundred";
              INT    last2 = n MOD 100;
              last2 = 0
         THEN hundreds
         ELSE hundreds + " and " + two digits( last2 )
         FI # three digits # ;
    # returns the "name" of n                                                 #
    OP NAME = ( NUMBER n )STRING:
       IF   n < 0 THEN "negative " + NAME - n
       ELIF n = 0 THEN "zero"
       ELSE # have a positive number to name                                  #
            NUMBER   v         := n;
            STRING   result    := "";
            INT      power pos := 0;
            WHILE v /= 0 DO
                IF   INT v999 = TOINT ( v MOD 1000 );
                     v999 /= 0
                THEN STRING component := three digits( v999 );
                     IF power pos > 0 THEN
                         component +:= " " + power suffix[ power pos ]
                     FI;
                     IF result /= "" THEN component +:= " " FI;
                     component +=: result
                FI;
                power pos +:= 1;
                v OVERAB 1000
            OD;
            result
       FI # NAME # ;
    # returns the number name of n, only needed of NUMBER is not INT          #
    OP NAME   = ( INT n )STRING: NAME NUMBER( n );

    # returns a "hash" of s - s with the letters in order, spaces are ignored #
    OP HASHOF = ( STRING s )STRING:
       BEGIN
           [ 1 : 26 ]INT counts; FOR i TO UPB counts DO counts[ i ] := 0 OD;
           FOR i FROM LWB s TO UPB s DO
               CHAR c = s[ i ];
               IF c /= " " THEN counts[ LETTER c ] +:= 1 FI
           OD;
           STRING result := "";
           FOR i FROM LETTER "a" TO LETTER "z" DO
               IF counts[ i ] > 0 THEN result +:= counts[ i ] * REPR ( ABS "a" + i - 1 ) FI
           OD;
           result
       END # HASHOF # ;

    # mode to hold details of a possible cardinal name anagram                #
    MODE CARDINALANA = STRUCT( STRING h                  # "hash" of the name #
                             , INT    n                          # the number #
                             , INT    count # count of numbers with this hash #
                             );
    # exchanges the values of swap a and with b                               #
    OP   =:= = ( REF CARDINALANA swap a, with b )VOID:
         BEGIN CARDINALANA t = with b; with b := swap a; swap a := t END;
    # in-place quick sort a[ lb : ub ] using qs lt for the comparisons        #
    PROC quicksort anagrams = ( REF[]CARDINALANA qs a
                              , INT              lb, ub
                              , PROC(CARDINALANA,CARDINALANA)BOOL qs lt
                              ) VOID:
         IF ub <= lb
         THEN SKIP                      # at most 1 element - no need to sort #
         ELSE                           # more than one element, so must sort #
            INT qs left  := lb;
            INT qs right := ub;
            # choosing the middle element of the array as the pivot           #
            CARDINALANA pivot := qs a[ qs left + ( ( qs right + 1 ) - qs left ) OVER 2 ];
            WHILE
                WHILE IF qs left  <= ub THEN qs lt( qs a[ qs left  ], pivot ) ELSE FALSE FI
                DO
                    qs left  +:= 1
                OD;
                WHILE IF qs right >= lb THEN qs lt( pivot, qs a[ qs right ] ) ELSE FALSE FI
                DO
                    qs right -:= 1
                OD;
                qs left <= qs right
            DO
                qs a[ qs left  ] =:= qs a[ qs right ];
                qs left          +:= 1;
                qs right         -:= 1
            OD;
            quicksort anagrams( qs a, lb,      qs right, qs lt );
            quicksort anagrams( qs a, qs left, ub,       qs lt )
         FI # quicksort anagrams # ;

    BEGIN
        []INT tests = ( 1 000, 10 000 );
        FOR max pos FROM LWB tests TO UPB tests DO
            INT max number = tests[ max pos ]; # largest number for this test #
            # construct a table of the possible anagrams                      #
            [ 0 : max number + 1 ]CARDINALANA anagram;
            FOR n FROM 0 TO max number DO
               h OF anagram[ n ]     := HASHOF NAME n;
               n OF anagram[ n ]     := n;
               count OF anagram[ n ] := 0
            OD;
            # add a final dummy element to simplify counting the anagrams     #
            h OF anagram[ max number + 1 ]     := "z" * 26;
            n OF anagram[ max number + 1 ]     := -1;
            count OF anagram[ max number + 1 ] := 0;
            # sort the possible anagrams into "hash" and number order         #
            quicksort anagrams( anagram, 0, max number
                              , ( CARDINALANA a, b )BOOL: h OF a < h OF b
                                                     OR ( h OF a = h OF b AND n OF a < n OF b )
                              );
            # add counts of each anagram to the table                         #
            STRING max value  := "";
            INT    prev start := LWB anagram;
            STRING prev value := max value;
            INT  max count  := 0, this count := 0;
            FOR i FROM LWB anagram TO UPB anagram DO
                STRING value := h OF anagram[ i ];
                IF value = prev value THEN
                    this count +:= 1
                ELSE
                    IF this count > max count THEN
                        max count := this count
                    FI;
                    FOR p FROM prev start TO i DO count OF anagram[ p ] := this count OD;
                    prev value := value;
                    prev start := i;
                    this count := 1
                FI
            OD;
            PROC show group = ( []INT group )VOID:
                 BEGIN
                    INT pos := -1;
                    print( ( "        [" ) );
                    FOR i FROM LWB group TO UPB group DO
                        IF ( pos +:= 1 ) = 10 THEN print( ( newline, "         " ) ); pos := 0 FI;
                        print( ( " ", whole( group[ i ], IF group[ i ] < 100 THEN -3 ELSE 0 FI ) ) )
                    OD;
                    print( ( " ]", newline ) )
                 END # show group # ;
            # show some features of the anagrams                              #
            # count the anagrams                                              #
            INT anagram count := 0;
            FOR i FROM LWB anagram + 1 TO UPB anagram DO
                IF count OF anagram[ i ] > 1 AND h OF anagram[ i ] /= h OF anagram[ i - 1 ] THEN
                    anagram count +:= 1
                FI
            OD;
            IF max pos = 1 THEN
                # first test - show the first 30 anagrams                     #
                [ 1 : max number ]INT first;
                FOR i TO max number DO
                    first[ i ] := IF count OF anagram[ i ] > 1 THEN n OF anagram[ i ] ELSE max int FI
                OD;
                print( ( "    the first 30 anagrams:", newline ) );
                show group( ( QUICKSORT first )[ 1 : 30 ] )
            FI;
            print( ( "Up to ", whole( max number, 0 ) ) );
            print( ( " there are ", whole( anagram count, 0 ), " anagrams", newline ) );
            # show the largest group(s) of anagrams                           #
            print( ( "    the largest group(s) of anagrams:", newline ) );
            [ 1 : max count ]INT a group;
            INT a pos  := 0;
            prev value := "";
            FOR i FROM LWB anagram TO UPB anagram DO
                IF count OF anagram[ i ] = max count THEN
                    IF prev value = "" OR h OF anagram[ i ] /= prev value THEN
                        IF prev value /= "" THEN
                            show group( a group )
                        FI;
                        prev value := h OF anagram[ i ];
                        a pos := 0
                    FI;
                    a group[ a pos +:= 1 ] := n OF anagram[ i ]
                FI
            OD;
            show group( a group )
        OD
    END
END
