BEGIN # find the number of ways of taking down columns of lanterns          #
    # translation of the Python "Math" sample                               #

    PR precision 256 PR            # set number of digits for LONG LONG INT #
            # may need to be increased, depending on the number of lanterns #

    OP   FACTORIAL = ( INT n )LONG LONG INT:
         BEGIN
            LONG LONG INT result := 1;
            LONG LONG INT long n := 0;
            TO n DO result *:= ( long n +:= 1 ) OD;
            result
         END # FACTORIAL # ;

    PROC get lantern = ( REF[]INT arr )LONG LONG INT:
         BEGIN
            LONG LONG INT res := 0;
            INT           tot := 0;
            FOR i FROM LWB arr TO UPB arr DO
                tot +:= arr[ i ]
            OD;
            res := FACTORIAL tot;
            FOR i FROM LWB arr TO UPB arr DO
                res OVERAB FACTORIAL arr[ i ]
            OD;
            res
        END # get lantern # ;

    BEGIN
        INT n;
        print( ( "Columns> " ) );
        read( ( n, newline ) );
        [ 1 : n ]INT a;
        print( ( "lanterns per column> " ) );
        FOR i TO n DO
            read( ( a[ i ] ) )
        OD;
        print( ( whole( get lantern( a ), 0 ), newline ) )
    END
END
