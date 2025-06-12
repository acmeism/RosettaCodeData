BEGIN CO Solve the no connection puzzle
         the board looks like:
             A   B
            /|\ /|\
           / | X | \
          /  |/ \|  \
         C - D - E - F
          \  |\ /|  /
           \ | X | /
            \|/ \|/
             G   H
         we need to place 1..8 at A..G so that each connected
         value differs by at least 2 (e.g., A=1 and D=3 is OK
                                      but A=1 and D=2 is not)
      CO

    PROC not ok = ( INT x )BOOL: ABS x < 2;
    PROC ok = ( INT a, b, c, d, e, f, g, h )BOOL:
         IF   not ok( a - c ) OR not ok( a - d ) OR not ok( a - e ) THEN FALSE
         ELIF not ok( b - d ) OR not ok( b - e ) OR not ok( b - f ) THEN FALSE
         ELIF not ok( g - c ) OR not ok( g - d ) OR not ok( g - e ) THEN FALSE
         ELIF not ok( h - d ) OR not ok( h - e ) OR not ok( h - f ) THEN FALSE
         ELIF not ok( c - d ) OR not ok( d - e ) OR not ok( e - f ) THEN FALSE
         ELSE                                                            TRUE
         FI # ok # ;

    PROC is solution = ( []INT a )BOOL:
         ok( a[ 0 ], a[ 1 ], a[ 2 ], a[ 3 ], a[ 4 ], a[ 5 ], a[ 6 ], a[ 7 ] );

    # Heap's algorithm for generating permutations                           #
    #      - from the pseudo-code on the Wikipedia page                      #
    # have permutation is called for each generated permutation              #
    PROC generate = ( INT k, REF[]INT a, REF INT swap count, PROC([]INT,INT)VOID have permutation )VOID:
         IF k = 1 THEN
            have permutation( a, swap count )
         ELSE
            # Generate permutations with kth unaltered                       #
            # Initially k = length a                                         #
            generate( k - 1, a, swap count, have permutation );
            # Generate permutations for kth swapped with each k-1 initial    #
            FOR i FROM 0 TO k - 2 DO
                # Swap choice dependent on parity of k (even or odd)         #
                swap count +:= 1;
                INT swap item = IF ODD k THEN 0 ELSE i FI;
                INT t           = a[ swap item ];
                a[ swap item ] := a[ k - 1 ];
                a[ k - 1     ] := t;
                generate( k - 1, a, swap count, have permutation )
            OD
         FI # generate # ;
    # generate permutations of a                                             #
    PROC permute = ( REF[]INT a, PROC([]INT,INT)VOID have permutation )VOID:
         BEGIN
            INT swap count := 0;
            generate( ( UPB a + 1 ) - LWB a, a[ AT 0 ], swap count, have permutation )
         END # permute # ;

    # handle a permutation #
    PROC possible solution = ( []INT p, INT swap count )VOID:
         IF is solution( p ) THEN                          # have a solution #
            IF first solution THEN
                print( ( "First solution found:", newline ) );
                OP   N = ( INT v )CHAR: REPR ( v + ABS "0" );
                CHAR a = N p[ 0 ], b = N p[ 1 ], c = N p[ 2 ], d = N p[ 3 ];
                CHAR e = N p[ 4 ], f = N p[ 5 ], g = N p[ 6 ], h = N p[ 7 ];
                print( ( "           ", a, "   ", b,                  newline ) );
                print( ( "          /|\ /|\",                         newline ) );
                print( ( "         / | X | \",                        newline ) );
                print( ( "        /  |/ \|  \",                       newline ) );
                print( ( "       ", c, " - ", d, " - ", e, " - ", f,  newline ) );
                print( ( "        \  |\ /|  /",                       newline ) );
                print( ( "         \ | X | /",                        newline ) );
                print( ( "          \|/ \|/",                         newline ) );
                print( ( "           ", g, "   ", h,                  newline ) );
                print( ( newline, "All solutions:", newline ) );
                first solution := FALSE
            FI;
            print( ( "    [" ) );
            FOR i FROM LWB p TO UPB p DO
               print( ( whole( p[ i ], 0 ) ) );
               IF i = UPB p THEN print( ( "]" ) ) ELSE print( ( ", " ) ) FI
            OD;
            print( ( " after ", whole( swap count, 0 ), " swaps", newline ) )
         FI # possible solution # ;

    [ 1 : 8 ]INT items  := ( 1, 2, 3, 4, 5, 6, 7, 8 );
    BOOL first solution := TRUE;
    permute( items, possible solution )

END
