# MODE representing a uncertain number #
MODE UNCERTAIN = STRUCT( REAL v, uncertainty );

# add a costant and an uncertain value #
OP + = ( INT  c, UNCERTAIN u )UNCERTAIN: UNCERTAIN( v OF u + c, uncertainty OF u );
OP + = ( UNCERTAIN u, INT  c )UNCERTAIN: c + u;
OP + = ( REAL c, UNCERTAIN u )UNCERTAIN: UNCERTAIN( v OF u + c, uncertainty OF u );
OP + = ( UNCERTAIN u, REAL c )UNCERTAIN: c + u;
# add two uncertain values #
OP + = ( UNCERTAIN a, b )UNCERTAIN: UNCERTAIN( v OF a + v OF b
                                             , sqrt( ( uncertainty OF a * uncertainty OF a )
                                                   + ( uncertainty OF b * uncertainty OF b )
                                                   )
                                             );

# negate an uncertain value #
OP - = ( UNCERTAIN a )UNCERTAIN: ( - v OF a, uncertainty OF a );

# subtract an uncertain value from a constant #
OP - = ( INT  c, UNCERTAIN u )UNCERTAIN: c + - u;
OP - = ( REAL c, UNCERTAIN u )UNCERTAIN: c + - u;
# subtract a constant from an uncertain value #
OP - = ( UNCERTAIN u, INT  c )UNCERTAIN: u + - c;
OP - = ( UNCERTAIN u, REAL c )UNCERTAIN: u + - c;
# subtract two uncertain values #
OP - = ( UNCERTAIN a, b )UNCERTAIN: a + - b;

# multiply a constant by an uncertain value #
OP * = ( INT  c, UNCERTAIN u )UNCERTAIN: UNCERTAIN( v OF u + c, ABS( c * uncertainty OF u ) );
OP * = ( UNCERTAIN u, INT  c )UNCERTAIN: c * u;
OP * = ( REAL c, UNCERTAIN u )UNCERTAIN: UNCERTAIN( v OF u + c, ABS( c * uncertainty OF u ) );
OP * = ( UNCERTAIN u, REAL c )UNCERTAIN: c * u;
# multiply two uncertain values #
OP * = ( UNCERTAIN a, b )UNCERTAIN:
   BEGIN
       REAL av = v OF a;
       REAL bv = v OF b;
       REAL f  = av * bv;
       UNCERTAIN( f, f * sqrt( ( uncertainty OF a / av ) + ( uncertainty OF b / bv ) ) )
   END # * # ;

# construct the reciprocol of an uncertain value #
OP ONEOVER = ( UNCERTAIN u )UNCERTAIN: ( 1 / v OF u, uncertainty OF u );
# divide a constant by an uncertain value #
OP / = ( INT  c, UNCERTAIN u )UNCERTAIN: c * ONEOVER u;
OP / = ( REAL c, UNCERTAIN u )UNCERTAIN: c * ONEOVER u;
# divide an uncertain value by a constant #
OP / = ( UNCERTAIN u, INT  c )UNCERTAIN: u * ( 1 / c );
OP / = ( UNCERTAIN u, REAL c )UNCERTAIN: u * ( 1 / c );
# divide two uncertain values #
OP / = ( UNCERTAIN a, b )UNCERTAIN: a * ONEOVER b;

# exponentiation #
OP ^ = ( UNCERTAIN u, INT c )UNCERTAIN:
   BEGIN
       REAL f = v OF u ^ c;
       UNCERTAIN( f, ABS ( ( f * c * uncertainty OF u ) / v OF u ) )
   END # ^ # ;
OP ^ = ( UNCERTAIN u, REAL c )UNCERTAIN:
   BEGIN
       REAL f = v OF u ^ c;
       UNCERTAIN( f, ABS ( ( f * c * uncertainty OF u ) / v OF u ) )
   END # ^ # ;

# test the above operatrs by using them to find the pythagorean distance between the two sample points #
UNCERTAIN x1 = UNCERTAIN( 100, 1.1 );
UNCERTAIN y1 = UNCERTAIN(  50, 1.2 );
UNCERTAIN x2 = UNCERTAIN( 200, 2.2 );
UNCERTAIN y2 = UNCERTAIN( 100, 2.3 );

UNCERTAIN d  = ( ( ( x1 - x2 ) ^ 2 ) + ( y1 - y2 ) ^ 2 ) ^ 0.5;

print( ( "distance: ", fixed( v OF d, 0, 2 ), " +/- ", fixed( uncertainty OF d, 0, 2 ), newline ) )
