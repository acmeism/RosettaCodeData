INT number of rows = 123;
MODE NAMEG = LONG INT;


[ number of rows ]REF[]NAMEG c;
[ number ofrows ]      NAMEG names;
FOR i TO UPB names DO
    names[ i ] := 0;
    c[ i ] := HEAP [ i ]NAMEG;
    FOR j TO i DO c[ i ][ j ] := 0 OD
OD;

FOR n TO UPB names DO
    FOR col TO n DO
        c[ n ][ col ] := IF   col = 1                         THEN 1
                         ELIF col = 2                         THEN n OVER 2
                         ELIF col >= n - 1                    THEN 1
                         ELIF ( n - col ) < col               THEN names[ n - col ]
                         ELIF ( n - col ) = col AND NOT ODD n THEN names[ n - col ]
                         ELSE
                             NAMEG partial sum := 0;
                             FOR k TO col DO partial sum +:= c[ n - col ][ k ] OD;
                             partial sum
                         FI
    OD;
    names[ n ]:= 0;
    FOR k TO n DO names[ n ] +:= c[ n ][ k ] OD
; IF n MOD 200 = 0 THEN print( ( "...", whole( n, 0 ), newline ) ) FI
OD;

# display the first 25 rows of the triangle #
FOR n TO 25 DO
    print( ( "(", whole( names[ n ], -6 ), ")", whole( n, -3 ), ":" ) );
    FOR col TO n DO
        print( ( " ", whole( c[ n ][ col ], -3 ) ) )
    OD;
    print( ( newline ) )
OD;

print( ( "   23: ", whole( names[    23 ], 0 ), newline ) );
print( ( "  123: ", whole( names[   123 ], 0 ), newline ) )
