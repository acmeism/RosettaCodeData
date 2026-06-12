BEGIN # find and count upside-down numbers - translation of Phix #
    PROC get counts = ( INT d, REF LONG INT first, last )LONG INT:
         BEGIN
             LONG INT count := first := last := 1;
             FOR i FROM 2 TO d DO
                 first := last + 1;
                 IF NOT ODD i THEN count *:= 9 FI;
                 last := first + count - 1
             OD;
             count
         END # get counts # ;
    PROC kth of n = ( LONG INT kth, digits, count )STRING:
         IF   digits = 0 THEN ""
         ELIF digits = 1 THEN "5"
         ELSE
            OP D = ( INT n )CHAR: REPR ( ABS "0" + n );
            LONG INT reduced count := count OVER 9;
            INT      d              = SHORTEN ( ( kth - 1 ) OVER reduced count );
            D ( 1 + d ) + kth of n( kth - ( d * reduced count ), digits - 2, reduced count ) + D ( 9 - d )
         FI # kth of n # ;
    PROC get which = ( LONG INT nth in, REF LONG INT count, first, last, kth, digits )STRING:
         BEGIN
            LONG INT nth := nth in;
            digits := count := first := last := 1;
            WHILE nth > last DO
                first   := last + 1;
                digits +:= 1;
                IF NOT ODD digits THEN count *:= 9 FI;
                last    := first + count - 1
            OD;
            kth := nth - first + 1;
            kth of n( kth, digits, count )
         END # get which # ;
    PROC ord = ( LONG INT n )STRING:
         IF   INT d2 = SHORTEN ( n MOD 100 );
              d2 >= 10 AND d2 <= 20
         THEN "th"
         ELSE CASE SHORTEN ( n MOD 10 ) IN "st", "nd", "rd" OUT "th" ESAC
         FI # ord # ;
    print( ( "The first 50 upside down numbers:", newline ) );
    FOR i TO 50 DO
        STRING ud := get which( i
                              , LOC LONG INT, LOC LONG INT, LOC LONG INT
                              , LOC LONG INT, LOC LONG INT
                              );
        WHILE ( UPB ud - LWB ud ) < 3 DO " " +=: ud OD;
        print( ( ud, IF i MOD 10 /= 0 THEN " " ELSE newline FI ) )
    OD;
    print( ( newline ) );
    FOR d TO 7 DO
        LONG INT first := 0, last := 0;
        LONG INT count  = get counts( d, first, last );
        print( ( "There are ", whole( count, 0 ), " ", whole( d, 0 )
               , "-digit upside down numbers (the "
               , whole( first, 0 ), ord( first ), " to ", whole( last, 0 ), ord( last )
               , ")", newline
               )
             )
    OD;
    print( ( "(etc...)", newline, newline ) );
    []LONG INT position = ( 1, 2, 10, 11, 182, 500, 910, 911
                          , 5 000, 50 000, 500 000, 5 000 000, 50 000 000
                          , 500 000 000, 5 000 000 000, 50 000 000 000, 500 000 000 000
                          , 5 000 000 000 000, 50 000 000 000 000, 500 000 000 000 000
                          , 5 000 000 000 000 000
                          );
    FOR i FROM LWB position TO UPB position DO
        LONG INT w      = position[ i ];
        LONG INT count := 0, first := 0, last := 0, kth := 0, digits := 0;
        STRING   res    = get which( w, count, first, last, kth, digits );
        print( ( "The ", whole( w, 0 ), ord( w ), " upside down number"
               , " is the ", whole( kth, 0 ), ord( kth ), " ", whole( digits, 0 )
               , "-digit number (", res, ")", newline
               )
             )
    OD
END
