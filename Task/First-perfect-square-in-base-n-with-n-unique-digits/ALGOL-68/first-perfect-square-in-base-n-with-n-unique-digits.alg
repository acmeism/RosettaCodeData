BEGIN # find the first perfect square in base n with n unique digits n=1..16 #
    [ 0 : 15 ]BITS dmask; # masks for recording the digits in a BITS string  #
    dmask[ 0 ] := 16r1;
    FOR i TO UPB dmask DO dmask[ i ] := BIN ( 2 * ABS dmask[ i - 1 ] ) OD;
    # base digits                                                            #
    STRING digits = "0123456789abcdefghijklmnopqrstuvwxyz";
    # returns a string representation of n in base b                         #
    #         the result is balank padded on the left to at least w digits   #
    PROC to base = ( LONG INT n, INT b, w )STRING:
         BEGIN
            STRING result := "";
            LONG INT v := ABS n;
            WHILE v > 0 DO
                digits[ SHORTEN ( v MOD b ) + 1 ] +=: result;
                v OVERAB b
            OD;
            IF   INT len = ( UPB result - LWB result ) + 1;
                 len < w
            THEN
                 ( ( w - len ) * " " ) + result
            ELSE result
            FI
         END # to base # ;
    BITS all digits := dmask[ 0 ];
    FOR b FROM 2 TO 16 DO
        all digits    := all digits OR dmask[ b - 1 ];
        LONG INT root := 1;
        TO b - 1 DO root *:= b OD;
        root       := ENTIER long sqrt( root );
        BOOL found := FALSE;
        WHILE NOT found DO
            LONG INT square = root * root;
            LONG INT v     := square;
            BITS present   := 16r0;
            WHILE v > 0 DO
                present := present OR dmask[ SHORTEN ( v MOD b ) ];
                v OVERAB b
            OD;
            IF found := present = all digits THEN
                print( ( "Base: ", whole( b, -2 )
                       , ":", to base( root, b, 20 ), "^2 = ", to base( square, b, 0 )
                       , newline
                       )
                     )
            FI;
            root +:= 1
        OD
    OD
END
