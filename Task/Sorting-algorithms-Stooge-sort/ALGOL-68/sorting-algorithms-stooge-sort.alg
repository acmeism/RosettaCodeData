# swaps the values of the two REF INTs #
PRIO =:= = 1;
OP   =:= = ( REF INT a, b )VOID: ( INT t := a; a := b; b := t );

# returns the array of INTs sorted via the stooge sort algorithm #
PROC stooge sort = ( []INT array )[]INT:
     BEGIN
         PROC stooge sort segment = ( REF[]INT l, INT i, j )VOID:
             BEGIN
                 IF l[j] < l[i] THEN l[ i ] =:= l[ j ] FI;
                 IF j - i > 1
                 THEN
                     INT t := (j - i + 1) OVER 3;
                     stooge sort segment( l, i,     j - t );
                     stooge sort segment( l, i + t, j     );
                     stooge sort segment( l, i,     j - t )
                 FI
             END # stooge sort segment # ;

         [ LWB array : UPB array ]INT result := array;
         stooge sort segment( result, LWB result, UPB result );
         result
     END # stooge sort # ;

# test the stooge sort #
[]INT data = ( 67, -201, 0, 9, 9, 231, 4 );
print( ( "before: ", data, newline, "after:  ", stooge sort( data ), newline ) )
