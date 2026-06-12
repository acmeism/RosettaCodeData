BEGIN # count the ways of summing coins to a particular number - translation of the Go sample #
    INT countu := 0;  # order unimportant     #
    INT counti := 0;  # order important       #
    INT width  := 0;  # for printing purposes #

    PROC factorial = (INT n )INT:
         BEGIN
            INT prod := 1;
            FOR i FROM 2 TO n DO
                prod *:= i
            OD;
            prod
         END # factorial # ;

    OP LEN = ( []INT  a )INT: ( UPB a - LWB a ) + 1;
    OP LEN = ( STRING a )INT: ( UPB a - LWB a ) + 1;
    PROC append = ( []INT a, INT b )[]INT:
         BEGIN
            [ 1 : LEN a + 1 ]INT result;
            result[ 1 : LEN a ] := a;
            result[ LEN a + 1 ] := b;
            result
         END # append # ;
    OP TOSTRING = ( []INT a )STRING:
       BEGIN
            STRING result    := "[";
            STRING separator := "";
            FOR i FROM LWB a TO UPB a DO
                result +:= separator + whole( a[ i ], 0 );
                separator := " "
            OD;
            result +:= "]"
       END # TOSTRING # ;
    PROC pad = ( STRING a, INT pad width )STRING:
         IF INT len a = LEN a; len a >= pad width THEN a ELSE a + ( " " * ( pad width - len a ) ) FI;

    PROC count = ( INT want, []INT used, INT sum, []INT have, uindices, rindices )VOID:
         IF sum = want THEN
            countu +:= 1;
            counti +:= factorial( LEN used );
            IF countu < 11 THEN
                STRING uindices str = TOSTRING uindices;
                print( ( "  indices ", pad( uindices str, width ), " => used ", TOSTRING used, newline ) )
            FI
         ELIF sum < want AND LEN have /= 0 THEN
            INT this coin = have[ LWB have ];
            INT index     = rindices[ LWB rindices ];
            []INT rest    = have[ LWB have + 1 : ];
            count( want, append( used, this coin ), sum + this coin, rest,
                   append( uindices, index ), rindices[ LWB rindices + 1 : ] );
            count( want, used, sum, rest, uindices, rindices[ LWB rindices + 1 : ] )
         FI # count # ;

    PROC count coins = ( INT want, []INT coins, INT rqd width )VOID:
         BEGIN
            print( ( "Sum ", whole( want, 0 ), " from coins ", TOSTRING coins, newline ) );
            countu := 0;
            counti := 0;
            width  := rqd width;
            [ 0 : LEN coins - 1 ]INT rindices;
            FOR i FROM LWB rindices TO UPB rindices DO
                rindices[ i ] := i
            OD;
            count( want, []INT(), 0, coins, []INT(), rindices );
            IF countu > 10 THEN
                print( ( "  .......", newline ) );
                print( ( "  (only the first 10 ways generated are shown)", newline ) )
            FI;
            print( ( "Number of ways - order unimportant : ", whole( countu,  0 )
                   , " (as above)", newline ) );
            print( ( "Number of ways - order important   : ", whole( counti, 0 )
                   , " (all perms of above indices)", newline, newline ) )
         END # count coins # ;

    BEGIN # task #
        count coins(  6, ( 1, 2, 3, 4, 5 ), 7 );
        count coins(  6, ( 1, 1, 2, 3, 3, 4, 5 ), 9 );
        count coins( 40, ( 1, 2, 3, 4, 5, 5, 5, 5, 15, 15, 10, 10, 10, 10, 25, 100 ), 20 )
    END
END
