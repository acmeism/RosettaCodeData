# set the precision of LONG LONG INT - large enough for !n up to ! 10 000 #
PR precision 36000 PR
# stores left factorials in an array #
# we calculate the left factorials, storing their values in the "values" array #
# if step is <= 1, we store we store every left factorial, otherwise we store !x when x MOD step = 0 #
# note this means values[ 0 ] is always !0 #
PROC get left factorials = ( REF[]LONG LONG INT values, INT step )VOID:
     BEGIN
         INT store position        := LWB values;
         INT max values            := UPB values;
         LONG LONG INT result      := 0;
         LONG LONG INT factorial k := 1;
         FOR k FROM 0
         WHILE
             IF IF step <= 1 THEN TRUE ELSE k MOD step = 0 FI THEN
                 values[ store position ] := result;
                 store position +:= 1
             FI;
             store position <= max values
         DO
             result      +:= factorial k;
             factorial k *:= ( k + 1 )
         OD
     END # get left factorials # ;

# returns the number of digits in n #
OP DIGITCOUNT = ( LONG LONG INT n )INT:
   BEGIN
        INT result := 1;
        LONG LONG INT v := ABS n;
        WHILE v > 100 000 000 DO
            result +:= 8;
            v OVERAB 100 000 000
        OD;
        WHILE v > 10 DO
            result +:= 1;
            v OVERAB 10
        OD;
        result
   END # DIGITCOUNT # ;

BEGIN
    print( ( "!n for n = 0(1)10", newline ) );
    [ 0 : 10 ]LONG LONG INT v;
    get left factorials( v, 1 );
    FOR i FROM 0 TO UPB v DO
        print( ( whole( v[ i ], 0 ), newline ) )
    OD
END;

BEGIN
    print( ( "!n for n = 20(10)110", newline ) );
    [ 0 : 11 ]LONG LONG INT v;
    get left factorials( v, 10 );
    FOR i FROM 2 TO UPB v DO
        print( ( whole( v[ i ], 0 ), newline ) )
    OD
END;

BEGIN
    print( ( "digit counts of !n for n = 1000(1000)10 000", newline ) );
    [ 0 : 10 ]LONG LONG INT v;
    get left factorials( v, 1 000 );
    FOR i FROM 1 TO UPB v DO
        print( ( whole( DIGITCOUNT v[ i ], 0 ), newline ) )
    OD
END
