BEGIN
    PR precision 250 PR
    LONG LONG INT n := 0;
    FOR i FROM 0 TO 111 DO
        LONG LONG INT n3 = ( n * 10 ) + 3;
        IF i > 84 THEN
            STRING v := whole( n3 * n3, 0 );
            INT pos := 0;
            STRING pattern := "123456790";
            INT    p len   := ( UPB pattern - LWB pattern ) + 1;
            WHILE string in string( pattern, pos, v ) DO
                v := v[ 1 : pos - 1 ] + "A" + v[ pos + p len : ]
            OD;
            pattern := "987654320";
            WHILE string in string( pattern, pos, v ) DO
                v := v[ 1 : pos - 1 ] + "Z" + v[ pos + p len : ]
            OD;
            print( ( whole( i, -3 ), " ", v, newline ) )
        FI;
        n *:= 10 +:= 1
    OD
END
