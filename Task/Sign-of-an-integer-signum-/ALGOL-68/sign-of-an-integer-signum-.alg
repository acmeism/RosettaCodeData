BEGIN

    PROC signum = ( INT x )INT: IF ABS x = 0 THEN x ELIF x < 0 THEN -1 ELSE 1 FI;

    FOR x FROM 0 TO 3 DO
        print( ( whole( -x, -2 ), " -> ", whole( signum( -x ), -2 ), "; "    ) );
        print( ( whole(  x, -2 ), " -> ", whole( signum(  x ), -2 ), newline ) )
    OD
END
