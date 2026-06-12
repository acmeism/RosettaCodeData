BEGIN # Romberg Integration - translation of the Wren sample                     #

    # MODE returned by the romberg procedure, delta is the difference between    #
    # the final result and the previous step value                               #
    MODE RR = STRUCT( REAL value, REAL delta );

    PROC f8 = ( REAL v )STRING: IF ABS v < 1 THEN fixed( v, -10, 8 ) ELSE fixed( v, 0, 8 ) FI;

    # Prints a row of the Romberg table. r is assumed to be [1:n]                #
    PROC print row = ( INT i, []REAL r )VOID:
         BEGIN
            print( ( "R[", whole( i, 0 ), "] =" ) );
            FOR j FROM 0 TO i DO print( ( " ", f8( r[ j ] ) ) ) OD;
            print( ( newline ) )
         END # print row # ;

    CO Calculates the integral of a function using Romberg integration.
       Args:
           f:         The function to integrate.
           a:         Lower limit of integration.
           b:         Upper limit of integration.
           max steps: Maximum number of steps.
           acc:       Desired accuracy.

       Returns:
           The approximate value of the integral and the difference
           between the final 2 steps
    CO
    PROC romberg = ( PROC(REAL)REAL f, REAL a, b, INT max steps, REAL acc )RR:
         BEGIN
             # Buffers for storing previous and current rows.                    #
             [ 0 : max steps - 1 ]REAL r1, r2; FOR i FROM 0 TO max steps - 1 DO r1[ i ] := r2[ i ] := 0 OD;
             REF[]REAL rp := r1, rc := r2, rt;          # "pointers" to the rows #
             REAL h := b - a;                                        # step size #
             rp[ 0 ] := ( f( a ) + f( b ) ) * h * 0.5;  # first trapezoidal step #
             print row( 0, rp );
             INT ep := 1;
             RR result := ( rp[ 0 ], ( 2 * acc ) + 1 );
             FOR i TO max steps - 1 WHILE delta OF result >= acc DO
                 h     /:= 2;
                 REAL c := 0;
                 FOR j TO ep DO c +:= f( a + ( 2 * j - 1 ) * h ) OD;
                 rc[ 0 ] := h * c + 0.5 * rp[ 0 ];
                 FOR j TO i DO
                     INT nk = 4 ^ j;
                     rc[ j ] := ( nk * rc[ j - 1 ] - rp[ j - 1 ] ) / ( nk - 1 )
                 OD;
                 # Print i'th row of R, R[i][i] is the best estimate so far.     #
                 print row( i, rc );
                 value OF result := rc[ i ];
                 delta OF result := ABS ( rp[ i - 1 ] - rc[ i ] );
                 rt  := rp;          # Swap Rp, Rc as we only need the last row. #
                 rp  := rc;
                 rc  := rt;
                 ep *:= 2
             OD;
             result                                      # return our best guess #
         END # romberg # ;

    BEGIN                                                                # tests #
        print( ( "Integration of sin(x) over [0, 1] with a maximum of 5 steps.",       newline ) );
        RR rsin = romberg( sin, 0, 1, 5, 1e-8 );
        print( ( f8( value OF rsin ), "     delta: ", float( delta OF rsin, -14, 8, 3 ), newline ) );
        print( ( newline ) );
        print( ( "Integration of exp(x) over [-3, 3] with a maximum of 5 steps.",      newline ) );
        RR rexp = romberg( exp, -3, 3, 5, 1e-8 );
        print( ( f8( value OF rexp ), "     delta: ", float( delta OF rexp, -14, 8, 3 ), newline ) )
    END
END
