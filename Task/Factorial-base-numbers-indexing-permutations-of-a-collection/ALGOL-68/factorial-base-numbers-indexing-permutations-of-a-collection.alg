BEGIN # factorial base numbers indexing permutations of a collection #
      # - translated from the Phix/FreeBASIC samples #

    PROC print sequence = ( []INT s )VOID:
         BEGIN
            print( ( "  " ) );
            IF UPB s >= LWB s THEN
                FOR j FROM LWB s TO UPB s DO
                    print( ( whole( s[ j ], 0 ) ) )
                OD
            FI;
            print( ( newline ) )
         END # print sequence # ;

    PROC factorial = ( INT n )LONG INT: IF n <= 1 THEN 1 ELSE n * factorial( n - 1 ) FI;

    PROC tagset = ( INT n )[]INT:
         BEGIN
            [ 1 : n ]INT result;
            FOR i TO n DO result[ i ] := i OD;
            result
         END # tagset # ;

    PROC show cards = ( []INT s )VOID:
         BEGIN
            STRING cards = "AKQJT98765432", suits = "SHDC";
            FOR i FROM LWB s TO UPB s DO
                INT c = s[ i ] - 1;
                STRING card = cards[ ( c MOD 13 ) + 1 ] + suits[ ( c OVER 13 ) + 1 ];
                print( ( card, IF i MOD 13 = 0 OR i = UPB s THEN newline ELSE space FI ) )
            OD;
            print( ( newline ) )
         END # show cards # ;

    PROC fperm = ( []INT fbn, omega )[]INT:
         BEGIN
            INT m := 0;
            [ LWB omega : UPB omega ]INT result := omega;
            FOR i FROM LWB fbn TO UPB fbn DO
                INT g = fbn[ i ];
                IF g > 0 THEN
                    INT tmp = result[ m + g + 1 ];
                    FOR j FROM m + g + 1 BY -1 TO m + 2 DO
                        result[ j ] := result[ j - 1 ]
                    OD;
                    result[ m + 1 ] := tmp
                FI;
                m +:= 1
            OD;
            result
         END # fperm # ;

    PROC factorial base numbers = ( INT size, BOOL count only )[]INT:
         BEGIN
            [ 1 : size ]INT res; FOR i TO size DO res[ i ] := 0 OD;
            # count the number of results #
            INT count := 0;
            FOR n FROM 0 WHILE INT radix := 2;
                               INT k     := n;
                               WHILE k > 0 DO
                                   k OVERAB radix;
                                   radix +:= 1
                               OD;
                               radix <= size + 2
            DO                 count +:= 1
            OD;
            [ 1 : IF count only THEN 0 ELSE count * size FI ]INT results;
            FOR i TO UPB results DO results[ i ] := 0 OD;
            INT results pos := - size;
            IF NOT count only THEN
                # want the results, not just a count #
                FOR n FROM 0 WHILE INT radix := 2;
                                   INT k     := n;
                                   WHILE k > 0 DO
                                       IF NOT count only AND radix <= size + 1 THEN
                                           res[ size - radix + 2 ] := k MOD radix
                                       FI;
                                       k OVERAB radix;
                                       radix +:= 1
                                   OD;
                                   radix <= size + 2
                DO                 count +:= 1;
                                   results pos +:= size;
                                   results[ results pos + 1 : results pos + size ] := res
                OD
            FI;
            IF count only THEN count ELSE results FI
         END # factorial base numbers # ;

         # Generate random factorial base number sequence #
         PROC randfbn51 = []INT:
              BEGIN
                 [ 1 : 51 ]INT fbn51;
                 FOR i TO 51 DO fbn51[ i ] := ENTIER ( next random * ( 52 - i ) ) + 1 OD;
                 fbn51
              END # randfbn51 # ;

    BEGIN
        INT size = 3;
        []INT  fbns  = factorial base numbers( size, FALSE );
        []INT  omega = ( 0, 1, 2, 3 );
        FOR i TO UPB fbns OVER size DO
            FOR j TO size DO
                print( ( whole( fbns[ ( i - 1 ) * size + j ], 0 ), IF j = size THEN "" ELSE "." FI ) )
            OD;
            print( ( " ->" ) );
            [ 1 : size ]INT tmp;
            FOR j TO size DO tmp[ j ] := fbns[ ( i - 1 ) * size + j ] OD;
            []INT  result = fperm( tmp, omega );
            print sequence( result )
        OD;
        print( ( newline ) );
        []INT  count = factorial base numbers( 10, TRUE );
        print( ( "Permutations generated = ", whole( ( count )[ 1 ],  0 ), newline ) );
        print( ( " compared to 11! which = ", whole( factorial( 11 ), 0 ), newline ) );
        print( ( newline ) );
        [][]INT  fbn51s = ( ( 39, 49,  7, 47, 29, 30,  2, 12, 10,  3, 29, 37, 33, 17, 12, 31, 29
                            , 34, 17, 25,  2,  4, 25,  4,  1, 14, 20,  6, 21, 18,  1,  1,  1,  4
                            ,  0,  5, 15, 12,  4,  3, 10, 10,  9,  1,  6,  5,  5,  3,  0,  0,  0
                            )
                          , ( 51, 48, 16, 22,  3,  0, 19, 34, 29,  1, 36, 30, 12, 32, 12, 29, 30
                            , 26, 14, 21,  8, 12,  1,  3, 10,  4,  7, 17,  6, 21,  8, 12, 15, 15
                            , 13, 15,  7,  3, 12, 11,  9,  5,  5,  6,  6,  3,  4,  0,  3,  2,  1
                            )
                          , rand fbn51
                          );
        # Show all card arrangements #
        FOR i FROM LWB fbn51s TO UPB fbn51s DO show cards( fperm( fbn51s[ i ], tagset( 52 ) ) ) OD
    END
END
