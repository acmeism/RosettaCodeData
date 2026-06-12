BEGIN
    # reorders the elements of a using the Sattolo cycle              #
    # this operates on integer arrays, additional SATTOLO operators   #
    # could be defined for other types                                #
    # a is returned so we can write e.g. SATTOLO SATTOLO a to cycle   #
    # the elements twice                                              #
    OP SATTOLO = ( REF[]INT a )REF[]INT:
       BEGIN
            REF[]INT aa := a[ @ 0 ];
            FOR i FROM UPB aa BY -1 TO 1 DO
                INT j    = ENTIER ( next random * i );
                INT t    = aa[ i ];
                aa[ i ] := aa[ j ];
                aa[ j ] := t
            OD;
            a
       END # SATTOLO # ;
    BEGIN
        [ 1 : 10 ]INT a := []INT( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 )[ @ 1 ];
        TO 5 DO
            SATTOLO a;
            FOR i FROM LWB a TO UPB a DO print( ( " ", whole( a[ i ], -3 ) ) ) OD;
            print( ( newline ) )
        OD
    END
END
