BEGIN

MODE POINT = STRUCT( REAL x, y );

MODE POLYGON = STRUCT( STRING name, FLEX[ 1 : 0 ]POINT points );
PROC contains = ( POLYGON self, POINT p )BOOL:
     BEGIN
        BOOL odd := FALSE, REAL eps = 1e-9;
        PROC rayseg = ( POINT p in, a in, b in )BOOL:
             BEGIN
                PROC max = ( REAL m, n )REAL: IF m > n THEN m ELSE n FI;
                PROC min = ( REAL m, n )REAL: IF m < n THEN m ELSE n FI;
                POINT p := p in, a := a in, b := b in;
                IF y OF a > y OF b THEN POINT t = a; a := b; b := t FI;
                IF y OF p = y OF a OR y OF p = y OF b THEN y OF p+:= eps FI;
                IF y OF p < y OF a OR y OF p > y OF b OR x OF p > max( x OF a, x OF b )
                THEN FALSE
                ELIF x OF p < min( x OF a, x OF b )
                THEN TRUE
                ELSE
                    REAL red = IF x OF a = x OF b THEN max real ELSE ( y OF b - y OF a ) / ( x OF b - x OF a ) FI;
                    REAL blu = IF x OF a = x OF p THEN max real ELSE ( y OF p - y OF a ) / ( x OF p - x OF a ) FI;
                    blu >= red
                FI
             END # rayseq # ;

        INT len points = ( UPB points OF self - LWB points OF self ) + 1;
        FOR i FROM LWB points OF self TO UPB points OF self DO
            POINT a = ( points OF self )[ i ];
            POINT b = ( points OF self )[ ( i MOD len points ) + 1 ];
            IF rayseg( p, a, b ) THEN odd := NOT odd FI
        OD;
        odd
     END # contains # ;

[]POLYGON polygons =
    ( ( "square"
      , ( ( 0, 0 ), (  10,   0 ), ( 10, 10 ), ( 0,    10 ) )
      )
    , ( "squarehole"
      , ( ( 0, 0 ), (  10,   0 ), ( 10, 10 ), ( 0,    10 ), ( 2.5, 2.5 ), ( 7.5, 2.5 ), ( 7.5, 7.5 ), ( 2.5, 7.5 ) )
      )
    , ( "strange"
      , ( ( 0, 0 ), ( 2.5, 2.5 ), (  0, 10 ), ( 2.5, 7.5 ), ( 7.5, 7.5 ), (  10,  10 ), ( 10,    0 ), ( 2.5, 2.5 ) )
      )
    , ( "hexagon"
      , ( ( 3, 0 ), (   7,   0 ), ( 10,  5 ), ( 7,    10 ), ( 3,    10 ), (   0,   5 ) )
      )
    );
[]POINT points = ( ( 5, 5 ), (5 , 8 ), ( -10, 5 ), ( 0, 5 ), ( 10, 5 ), ( 8, 5 ), ( 10, 10 ) );

FOR p FROM LWB polygons TO UPB polygons DO
    POLYGON poly = polygons[ p ];
    print(( "Does '", name OF poly, "' contain the point..", newline ) );
    FOR i FROM LWB points TO UPB points DO
        POINT pt = points[ i ];
        print( ( "  ( ", fixed( x OF pt, -5, 1 ), ", ", fixed( y OF pt, -5, 1 ), " ) " ) );
        print( ( IF contains( poly, pt ) THEN " true" ELSE " false" FI, newline ) )
    OD;
    print( ( newline ) )
OD

END
