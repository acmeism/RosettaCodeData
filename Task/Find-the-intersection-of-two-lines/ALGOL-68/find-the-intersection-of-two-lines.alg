BEGIN
    # mode to hold a point #
    MODE POINT = STRUCT( REAL x, y );
    # mode to hold a line expressed as y = mx + c #
    MODE LINE  = STRUCT( REAL m, c );
    # returns the line that passes through p1 and p2 #
    PROC find line = ( POINT p1, p2 )LINE:
         IF x OF p1 = x OF p2 THEN
             # the line is vertical                 #
             LINE( 0, x OF p1 )
         ELSE
             # the line is not vertical             #
             REAL m = ( y OF p1 - y OF p2 ) / ( x OF p1 - x OF p2 );
             LINE( m, y OF p1 - ( m * x OF p1 ) )
         FI # find line # ;

    # returns the intersection of two lines - the lines must be distinct and not parallel #
    PRIO INTERSECTION = 5;
    OP   INTERSECTION = ( LINE l1, l2 )POINT:
         BEGIN
             REAL x = ( c OF l2 - c OF l1 ) / ( m OF l1 - m OF l2 );
             POINT( x, ( m OF l1 * x ) + c OF l1 )
         END # INTERSECTION # ;

    # find the intersection of the lines as per the task #
    POINT i = find line( POINT( 4.0, 0.0 ), POINT( 6.0, 10.0 ) )
              INTERSECTION find line( ( 0.0, 3.0 ), ( 10.0, 7.0 ) );
    print( ( fixed( x OF i, -8, 4 ), fixed( y OF i, -8, 4 ), newline ) )

END
