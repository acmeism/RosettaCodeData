PROC steepest descent = ( REF[]LONG REAL x, LONG REAL alphap, tolerance )VOID:
BEGIN
    LONG REAL alpha := alphap;
    LONG REAL g0    := g( x ); # Initial estimate of result. #
    # Calculate initial gradient. #
    [ LWB x : UPB x ]LONG REAL fi  := grad g( x );
    # Calculate initial norm. #
    LONG REAL del g := 0.0;
    FOR i FROM LWB x TO UPB x DO
        del g +:= fi[ i ] * fi[ i ]
    OD;
    del g       := long sqrt( del g );
    LONG REAL b := alpha / del g;
    # Iterate until value is <= tolerance. #
    WHILE del g > tolerance DO
        # Calculate next value. #
        FOR i FROM LWB x TO UPB x DO
            x[i] -:= b * fi[i]
        OD;
        # Calculate next gradient. #
        fi := grad g( x );
        # Calculate next norm. #
        del g := 0;
        FOR i FROM LWB x TO UPB x DO
            del g +:= fi[ i ] * fi[ i ]
        OD;
        del g := long sqrt( del g );
        IF del g > 0 THEN
            b     := alpha / del g;
            # Calculate next value. #
            LONG REAL g1 := g( x );
            # Adjust parameter. #
            IF g1 > g0 THEN
                alpha /:= 2
            ELSE
                g0 := g1
            FI
        FI
    OD
END # steepest descent # ;
# calculates the gradient of g(p).                                                     #
# The derivitives wrt x and y are (as in the Fortran sample ):                         #
# g' wrt x = 2( x - 1 )e^( - ( y^2 ) ) - 4xe^( -2( x^2) )y( y + 2 )                    #
# g' wrt y = ( -2( x-1 )^2ye^( - (y^2) )) + e^(-2( x^2 ) )( y + 2 ) + e^( -2( x^2 ) )y #
PROC grad g = ( []LONG REAL p )[]LONG REAL:
BEGIN
    [ LWB p : UPB p ]LONG REAL z;
    LONG REAL x = p[ 0 ];
    LONG REAL y = p[ 1 ];
    z[ 0 ] := 2 * ( x - 1 ) * long exp( - ( y * y ) )
            - 4 * x * long exp( -2 * ( x * x ) ) * y * ( y + 2 );
    z[ 1 ] := ( -2 * ( x - 1 ) * ( x - 1 ) * y ) * long exp( - y * y )
            + long exp( -2 * x * x ) * ( y + 2 )
            + long exp( -2 * x * x ) * y;
    z
END # grad g # ;
# Function for which minimum is to be found. #
# g( x, y ) = ( ( x - 1 )^2 )e^( - ( x^2 ) ) + y( y + 2 )e^( - 2(x^2)) #
PROC g = ( []LONG REAL x )LONG REAL:
    ( x[ 0 ] - 1 )
  * ( x[ 0 ] - 1 )
  * long exp( - x[ 1 ] * x[ 1 ] ) + x[ 1 ] * ( x[ 1 ] + 2 )
  * long exp( - 2 * x[ 0 ] * x[ 0 ] )
  ;
BEGIN
    LONG REAL          tolerance := 0.0000006;
    LONG REAL          alpha     := 0.1;
    [ 0 : 1 ]LONG REAL x         := ( []LONG REAL( 0.1, -1 ) )[ AT 0 ]; # Initial guess of location of minimum. #
    steepest descent( x, alpha, tolerance );
    print( ( "Testing steepest descent method:", newline ) );
    print( ( "The minimum is at x[0] = ", fixed( x[ 0 ], -10, 6 ), ", x[1] = ", fixed( x[ 1 ], -10, 6 ), newline ) )
END
