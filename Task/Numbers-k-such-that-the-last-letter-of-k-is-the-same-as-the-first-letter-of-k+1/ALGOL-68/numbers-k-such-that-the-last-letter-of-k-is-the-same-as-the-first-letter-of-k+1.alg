BEGIN # find numbers k where the name of k ends with the start of k + 1      #

    []CHAR unit start =       (      "o", "t", "t", "f", "f", "s", "s", "e", "n" );
    []CHAR tens start =       (      "t", "t", "t", "f", "f", "s", "s", "e", "n" );
    []CHAR unit end   = []CHAR( "y", "e", "o", "e", "r", "e", "x", "n", "t", "e" )[ AT 0 ];

    [ 0 : 99 ]CHAR s99;                      # starting characters for 0..99 #
    FOR i TO 99 DO
        s99[ i ] := IF   i < 10 THEN unit start[ i ]
                    ELIF i = 10 THEN "t"
                    ELIF i = 11 THEN "e"
                    ELIF i < 20 THEN unit start[ i - 10 ]
                    ELSE             tens start[ i OVER 10 ]
                    FI
    OD;
    s99[ 0 ] := "z";
    [ 0 : 99 ]CHAR e99;                        # ending characters for 0..99 #
    FOR i FROM  1 TO 99 DO e99[ i ] := unit end[ i MOD 10 ] OD;
    FOR i FROM 10 TO 19 DO e99[ i ] := "n" OD;
    e99[ 0 ] := "o"; e99[ 10 ] := "n"; e99[ 12 ] := "e";

    # prints a histogram of data scaled to fit in width                      #
    PROC show histogram = ( []INT data, INT width )VOID:
         IF LWB data <= UPB data THEN
             INT max value := data[ LWB data ];
             FOR i FROM LWB data + 1 TO UPB data DO
                 IF data[ i ] > max value THEN max value := data[ i ] FI
             OD;
             FOR i FROM LWB data TO UPB data DO
                 INT v = ROUND ( ( data[ i ] * width ) / max value );
                 print( ( whole( i, -2 ), ": ", v * "=", ( ( width - v ) + 1 ) * " " ) );
                 print( ( " (", whole( data[ i ], 0 ), ")", newline ) )
             OD
         FI # show histogram # ;

    [ 0 : 9 ]INT d count; FOR i FROM LWB d count TO UPB d count DO d count[ i ] := 0 OD;
    CHAR   prev end     := "o"; # zero #
    INT    next to show := 1 000;
    INT    count        := 0;
    print( ( "The first 50 numbers:", newline ) );
    FOR n WHILE count < 1 000 000 DO
        INT  k          = n - 1;
        INT  ddd       := n; WHILE ddd >= 1 000 DO ddd OVERAB 1 000 OD;
        CHAR curr start = IF   ddd < 100
                          THEN s99[ ddd ]
                          ELSE unit start[ ddd OVER 100 ]
                          FI;
        IF curr start = prev end THEN
            count +:= 1;
            d count[ k MOD 10 ] +:= 1;
            IF count <= 50 THEN
                print( ( " ", whole( k, -4 ) ) );
                IF count MOD 10 = 0 THEN print( ( newline ) ) FI
            ELIF count = next to show THEN
                print( ( newline ) );
                print( ( "The ", whole( count, 0 ), "th number is: ", whole( k, 0 ), newline ) );
                print( ( "Breakdown by final digit of the numbers:", newline ) );
                show histogram( d count, 60 );
                next to show *:= 10
            FI
        FI;
        INT n99   = n MOD 100;
        prev end := IF   n99 > 0
                    THEN e99[ n99 ]
                    ELIF n MOD 1 000 000 = 0
                    THEN "n"
                    ELSE "d"
                    FI
    OD
END
