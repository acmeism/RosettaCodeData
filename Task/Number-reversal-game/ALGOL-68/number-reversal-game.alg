BEGIN # play the number reversal game                                        #

CO  begin code from the Knuth shuffle task                                  CO
PROC between = (INT a, b)INT :
(
  ENTIER (random * ABS (b-a+1) + (a<b|a|b))
);

PROC knuth shuffle = (REF[]INT a)VOID:
(
  FOR i FROM LWB a TO UPB a DO
    INT j = between(LWB a, UPB a);
    INT t = a[i];
    a[i] := a[j];
    a[j] := t
  OD
);
CO  end   code from the Knuth shuffle task                                  CO

    []INT ordered digits = ( 1, 2, 3, 4, 5, 6, 7, 8, 9 );
    [ 1 : 9 ]INT digits := ordered digits;
    knuth shuffle( digits );

    # ignore invalid data in stand in                                        #
    on value error( stand in, ( REF FILE f )BOOL: TRUE );

    PROC print digits = VOID:                            # prints the digits #
         BEGIN
            print( ( "The digits are:" ) );
            FOR i TO 9 DO print( ( whole( digits[ i ], -2 ) ) ) OD;
            print( ( newline ) )
         END # print digits # ;

    OP   = = ( []INT a, b )BOOL:                    # returns TRUE if a = b #
         IF LWB a /= LWB b OR UPB a /= UPB b THEN
            FALSE                            # a and b have different bounds #
         ELSE
            # a and b ave the same bounds                                    #
            BOOL same := TRUE;
            FOR i FROM LWB a TO UPB a WHILE same DO same := a[ i ] = b[ i ] OD;
            same
         FI # = # ;
    OP   /= = ( []INT a, b )BOOL: NOT ( a = b ); # returns TRUE if a not = b #

    INT count := 0;

    print digits;
    WHILE digits /= ordered digits DO
        print( ( "How many digits to reverse (2-9)? " ) );
        INT n := 0;
        read( ( n, newline ) );
        IF n >= 2 AND n <= 9 THEN
            # reverse the n left-most digits                                 #
            count +:= 1;
            INT r pos := n;
            FOR pos TO n OVER 2 DO
                INT t            = digits[ r pos ];
                digits[ r pos ] := digits[ pos   ];
                digits[ pos   ] := t;
                r pos          -:= 1
            OD;
            print digits
        FI
    OD;
    print( ( newline, "You ordered the digits in ", whole( count, 0 ), " moves", newline ) )

END
