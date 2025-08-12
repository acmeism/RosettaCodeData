BEGIN # find some Humble numbers - numbers with no prime factors above 7      #
    INT max humble       = 2048;
    INT max shown humble = 50;
    PROC min = ( INT a, b )INT: IF a < b THEN a ELSE b FI;
    [ 1 : max humble ]INT h;
    [ 0 : 6 ]INT h count;
    FOR i FROM LWB h count TO UPB h count DO h count[ i ] := 0 OD;
    INT p2    := 2, p3    := 3, p5    := 5, p7    := 7;
    INT last2 := 1, last3 := 1, last5 := 1, last7 := 1;
    # 1 is the first humble number ( 2^0 * 3^0 * 5^0 * 7^0 ) and has 1 digit  #
    h[ 1 ] := 1;
    h count[ 1 ] := 1;
    print( ( "1" ) );
    FOR n FROM 2 TO max humble DO
        # the next humble number is the lowest of the next multiples of       #
        #     2, 3, 5, 7                                                      #
        INT m = min( min( min( p2, p3 ), p5 ), p7 );
        h[ n ] := m;
        IF n <= max shown humble THEN print( ( " ", whole( m, 0 ) ) ) FI;
        IF m = p2 THEN p2 := 2 * h[ last2 +:= 1 ] FI;
        IF m = p3 THEN p3 := 3 * h[ last3 +:= 1 ] FI;
        IF m = p5 THEN p5 := 5 * h[ last5 +:= 1 ] FI;
        IF m = p7 THEN p7 := 7 * h[ last7 +:= 1 ] FI;
        h count[ IF   m <        10 THEN 1
                 ELIF m <       100 THEN 2
                 ELIF m <     1 000 THEN 3
                 ELIF m <    10 000 THEN 4
                 ELIF m <   100 000 THEN 5
                 ELIF m < 1 000 000 THEN 6
                 ELSE                    0
                 FI
               ] +:= 1
    OD;
    print( ( newline ) );
    FOR i TO 6 DO
        print( ( "There are "
               , whole( h count[ i ], -4 )
               , " Humble numbers with "
               , whole( i, 0 )
               , " digits"
               , newline
               )
             )
    OD
END
