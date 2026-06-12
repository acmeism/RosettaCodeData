BEGIN
    # shifts in place the elements of a left by n                          #
    PRIO <<:= = 1;
    OP   <<:= = ( REF[]INT a, INT n )REF[]INT:
         BEGIN
            INT    a length = ( UPB a - LWB a ) + 1;
            IF n < a length AND n > 0 THEN
                # the amount to shift is less than the length of the array #
                [ 1 : a length ]INT shifted;
                shifted[ 1                    : a length - n ] := a[ n + 1 :   @ 1 ];
                shifted[ ( a length + 1 ) - n :              ] := a[ 1     : n @ 1 ];
                a[ @ 1 ] := shifted
            FI;
            a
         END # <<:= # ;
    # prints the elements of v                                             #
    OP   PRINT = ( []INT v )VOID:
         BEGIN
            print( ( "[" ) );
            IF LWB v <= UPB v THEN
                print( ( whole( v[ LWB v ], 0 ) ) );
                FOR i FROM LWB v + 1 TO UPB v DO
                    print( ( "," , whole( v[ i ], 0 ) ) )
                OD
            FI;
            print( ( "]" ) )
         END # PRINT # ;
    [ 1 : 9 ]INT list := ( 1, 2, 3, 4, 5, 6, 7, 8, 9 );
    PRINT list;
    print( ( " -> " ) );
    list <<:= 3;
    PRINT list;
    print( ( newline ) )
END
