BEGIN # find words with 4 or more characters that contain only hex digits a-f #

    PR read "files.incl.a68" PR                      # include file utilities #

    INT max words = 100;               # guess at the maximum number of words #
    MODE HEXWORD  = STRUCT( STRING word, LONG INT value, INT root, INT len );
    [ 1 : max words ]HEXWORD hw;

    # returns TRUE if word is a hex-word ( contains only a-f and is at least  #
    #         four characters long, FALSE otherwise                           #
    # if word is a hex-word, it is stored in the hw table                     #
    # count so far contains the count of preceding hex-words                  #
    PROC find hex words = ( STRING word, INT count so far )BOOL:
         IF INT word len = ( UPB word + 1 ) - LWB word;
            word len < 4
         THEN FALSE                                        # word is too short#
         ELSE                            # word is at least 4 characters long #
            BOOL     is hex word := word /= "";
            LONG INT int word    := 0;
            FOR i FROM LWB word TO UPB word
            WHILE is hex word := word[ i ] >= "a" AND word[ i ] <= "f"
            DO
                int word *:= 16;
                int word +:= ( ABS word[ i ] - ABS "a" ) + 10
            OD;
            IF NOT is hex word
            THEN FALSE                                       # not a hex word #
            ELSE                                            # have a hex word #
                LONG INT r := int word;            # compute the digital root #
                WHILE r > 9 DO
                    LONG INT dr := r MOD 10;
                    WHILE ( r OVERAB 10 ) > 0 DO dr +:= r MOD 10 OD;
                    r := dr
                OD;
                INT hw pos = count so far + 1;
                word  OF hw[ hw pos ] := word;
                value OF hw[ hw pos ] := int word;
                root  OF hw[ hw pos ] := SHORTEN r;
                len   OF hw[ hw pos ] := word len;
                TRUE
            FI
         FI # find hex words # ;

    # prints the HEXWORD hw                                                   #
    PROC show hex word = ( HEXWORD hword )VOID:
         BEGIN
            print( ( word OF hword, ": " ) );
            TO 12 - len OF hword DO print( ( " " ) ) OD;
            print( ( whole( value OF hword, -10 ) ) );
            print( ( " [ ", whole( root OF hword, 0 ), " ]", newline ) )
         END # show hex word # ;
    # Quicksorts in-place the array of HEXWORDS a, from lb to ub              #
    # on ascending value                                                      #
    PROC quicksort hw = ( REF[]HEXWORD a, INT lb, ub )VOID:
         IF ub > lb THEN                # more than one element, so must sort #
            INT left       := lb;
            INT right      := ub;
            # choosing the middle element of the array as the pivot           #
            LONG INT pivot := value OF a[ left + ( ( right + 1 ) - left ) OVER 2 ];
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
            quicksort hw( a, lb,   right );
            quicksort hw( a, left, ub    )
         FI # quicksort hw # ;

    # load hw with the hex-words from unixdict.txt                            #
    IF   INT count = "unixdict.txt" EACHLINE find hex words;
         count < 0
    THEN print( ( "Unable to open unixdict.txt", newline ) )
    ELSE # show the hex words in ascending order of digital root              #
         FOR r FROM 1 TO 9 DO
             FOR i FROM 1 TO count DO
                 IF root OF hw[ i ] = r THEN show hex word( hw[ i ] ) FI
             OD
         OD;
         print( ( "Found ", whole( count, 0 ), " hex words", newline, newline ) );
         # show the words in descending value order excluding those with less #
         # than 4 unique letters                                              #
         quicksort hw( hw, 1, count );
         INT count 4 := 0;
         FOR i FROM count BY -1 TO 1 DO
             # check the word has at least four different digits              #
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
             THEN          # have a hex word with at least 4 different digits #
                 count 4 +:= 1;
                 show hex word( hw[ i ] )
             FI
         OD;
         print( ( "Found ", whole( count 4, 0 ) ) );
         print( ( " hex words with 4 or more distinct digits", newline ) )
    FI

END
