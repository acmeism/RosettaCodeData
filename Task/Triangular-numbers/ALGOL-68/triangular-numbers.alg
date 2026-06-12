BEGIN # show some triangular, tetrahedral, ... numbers and roots             #
    # prints a row of LONG INTs, with a title, newlines after every per-line #
    # and each number in the specified width                                 #
    PROC show values = ( STRING title, []LONG INT v, INT per line, INT width )VOID:
         BEGIN
            print( ( title, ":", newline ) );
            INT on line := 0;
            FOR i FROM LWB v TO UPB v DO
                print( ( whole( v[ i ], -width ) ) );
                IF ( on line +:= 1 ) = per line THEN
                    print( ( newline ) );
                    on line := 0
                FI
            OD;
            IF on line /= 0 THEN print( ( newline ) ) FI;
            print( ( newline ) )
         END # show values # ;

    # calculate the first 30 triangular, tetrahedral, etc. numbers           #
    [ 1 : 30 ]LONG INT triangular;  triangular[  1 ] := 0;
    [ 1 : 30 ]LONG INT tetrahedral; tetrahedral[ 1 ] := 0;
    [ 1 : 30 ]LONG INT pentatopic;  pentatopic[  1 ] := 0;
    [ 1 : 30 ]LONG INT simplex12;   simplex12[   1 ] := 0;
    FOR i FROM 2 TO 30 DO
        triangular[  i ] := triangular[  i - 1 ] + i - 1;
        tetrahedral[ i ] := tetrahedral[ i - 1 ] + triangular[  i ];
        pentatopic[  i ] := pentatopic[  i - 1 ] + tetrahedral[ i ];
        simplex12[   i ] := pentatopic[  i     ]
    OD;
    FROM 5 TO 12 DO
        FOR i FROM 2 TO 30 DO
            simplex12[ i ] +:= simplex12[ i - 1 ]
        OD
    OD;
    show values( "First 30 Triangular  numbers", triangular,  6,  4 );
    show values( "First 30 Tetrahedral numbers", tetrahedral, 6,  5 );
    show values( "First 30 Pentatopic  numbers", pentatopic,  6,  6 );
    show values( "First 30 12-Simplex  numbers", simplex12,   6, 12 );

    # show some triangular, tetrahedral, etc. roots                          #

    # returns the cube root of x                                             #
    PROC long crt = ( LONG REAL x )LONG REAL: long exp( long ln( x ) / 3 );
    # returns a LONG REAL approximation to the  triangular root of x         #
    PROC  real triangular root = ( LONG INT x )LONG REAL: ( long sqrt( ( 8 * x ) + 1 ) - 1 ) / 2;
    # returns a LONG REAL approximation to the tetrahedral root of x         #
    PROC real tetrahedral root = ( LONG INT x )LONG REAL:
         BEGIN
             LONG REAL t = long sqrt( ( 9 * x * x ) - ( 1 / 27 ) );
             long crt( ( 3 * x ) + t ) + long crt( ( 3 * x ) - t ) - 1
         END # tetrahedral root # ;
    # returns a LONG REAL approximation to the  pentatopic root of x         #
    PROC  real pentatopic root = ( LONG INT x )LONG REAL:
         ( long sqrt( 5 + ( 4 * long sqrt( ( 24 * x ) + 1 ) ) ) - 3 ) / 2;
    # returns an integer root of x, if the approximation (possibly + 1 ) = x #
    #                               the approximation otherwise              #
    PROC try integer root = ( LONG INT x, LONG REAL real root, PROC( LONG INT )LONG INT f )LONG REAL:
         IF LONG INT ir = ENTIER real root;
            f( ir ) = x
         THEN ir
         ELIF f( ir + 1 ) = x
         THEN ir + 1
         ELSE real root
         FI # try integer root # ;
    # returns the  triangular root of x                                      #
    PROC  triangular root = ( LONG INT x )LONG REAL:
         try integer root( x
                         , real triangular root( x )
                         , ( LONG INT n )LONG INT: ( n * ( n + 1 ) ) OVER 2
                         );
    # returns the tetrahedral root of x                                      #
    PROC tetrahedral root = ( LONG INT x )LONG REAL:
         try integer root( x
                         , real tetrahedral root( x )
                         , ( LONG INT n )LONG INT: ( n * ( n + 1 ) * ( n + 2 ) ) OVER 6
                         );
    # returns the  pentatopic root of x                                      #
    PROC  pentatopic root = ( LONG INT x )LONG REAL:
         try integer root( x
                         , real pentatopic root( x )
                         , ( LONG INT n )LONG INT: ( n * ( n + 1 ) * ( n + 2 ) * ( n + 3 ) ) OVER 24
                         );
    []LONG INT root test = ( 7140, 21408696, 26728085384, 14545501785001 );
    FOR i FROM LWB root test TO UPB root test DO
        PROC show = ( LONG REAL x )STRING:
             IF ENTIER x = x THEN whole( x, -6 ) + "      " ELSE fixed( x, -12, 5 ) FI;
        print( ( "Roots of ", whole( root test[ i ], 0 ), newline, "   " ) );
        print( ( " triangular: ",  show(  triangular root( root test[ i ] ) ) ) );
        print( ( " tetrahedral: ", show( tetrahedral root( root test[ i ] ) ) ) );
        print( ( " pentatopic: ",  show(  pentatopic root( root test[ i ] ) ) ) );
        print( ( newline ) )
    OD
END
