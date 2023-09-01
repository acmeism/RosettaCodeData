BEGIN # test for overlapping 2D triangles - using the code from the Algol 68 #
      # sample for the Check if two polygons overlap task, the code of which #
      # is based on a translation of that tasks' Go which is a translation   #
      # of Wren                                                              #

    # In the following a polygon is represented as a row of vertices         #
    # and a vertex ( POINT ) by a pair of x, y coordinates in the plane      #

    MODE POINT      = STRUCT( REAL x,   y   );
    MODE PROJECTION = STRUCT( REAL min, max );
    MODE POLYGON    = FLEX[ 1 : 0 ]POINT;

    PRIO DOT = 3;
    OP   DOT = ( POINT v, other )REAL:
         ( x OF v * x OF other ) + ( y OF v * y OF other );

    # returns the axes of the polygon defined by poly                        #
    OP  AXES = ( POLYGON poly )[]POINT:
        BEGIN
            [ LWB poly : UPB poly ]POINT result;
            FOR i FROM LWB poly TO UPB poly DO
                INT j = IF i = UPB poly THEN LWB poly ELSE i + 1 FI;
                POINT vertex1 = poly[ i ];
                POINT vertex2 = poly[ j ];
                POINT edge    = ( x OF vertex1 - x OF vertex2, y OF vertex1 - y OF vertex2 );
                result[ i ]  := ( - y OF edge, x OF edge )
            OD;
            result
         END # AXES # ;

    # returns the projection of poly onto axis                               #
    PRIO PROJECTONTO = 3;
    OP   PROJECTONTO = ( POLYGON poly, POINT axis )PROJECTION:
         BEGIN
             REAL min := axis DOT poly[ LWB poly ];
             REAL max := min;
             FOR i FROM LWB poly + 1 TO UPB poly DO
                 REAL p = axis DOT poly[ i ];
                 IF   p < min THEN
                     min := p
                 ELIF p > max THEN
                     max := p
                 FI
             OD;
             PROJECTION( min, max )
         END # PROJECTONTO # ;

    PRIO OVERLAPS = 5;
    # returns TRUE if the projections proj1 and proj2 overlap,               #
    #         FALSE otherrwise                                               #
    OP   OVERLAPS = ( PROJECTION proj1, proj2 )BOOL:
         IF   max OF proj1 < min OF proj2 THEN FALSE
         ELIF max OF proj2 < min OF proj1 THEN FALSE
         ELSE                                  TRUE
         FI # OVERLAPS # ;

    # returns TRUE if the ppolygons poly1 and poly2 overlap,                 #
    #         FALSE otherrwise                                               #
    OP   OVERLAPS = ( POLYGON poly1, poly2 )BOOL:
         BEGIN
            []POINT axes1 = AXES poly1, axes2 = AXES poly2;
            BOOL does overlap := TRUE;
            FOR a FROM LWB axes1 TO UPB axes1 WHILE does overlap DO
                does overlap := ( poly1 PROJECTONTO axes1[ a ] )
                       OVERLAPS ( poly2 PROJECTONTO axes1[ a ] )
            OD;
            FOR a FROM LWB axes2 TO UPB axes2 WHILE does overlap DO
                does overlap := ( poly1 PROJECTONTO axes2[ a ] )
                       OVERLAPS ( poly2 PROJECTONTO axes2[ a ] )
            OD;
            does overlap
         END # OVERLAPS # ;

    # returns x as a string without trailing 0 decoimals                     #
    OP TOSTRING = ( REAL x )STRING:
         BEGIN
            STRING v       := fixed( x, -14, 11 );
            INT    end pos := UPB v;
            WHILE IF end pos < LWB v THEN FALSE ELSE v[ end pos ] = "0" FI DO
                end pos -:= 1
            OD;
            IF end pos >= LWB v THEN
                IF v[ end pos ] = "." THEN end pos -:= 1 FI
            FI;
            INT start pos := LWB v;
            WHILE IF start pos > end pos THEN FALSE ELSE v[ start pos ] = " " FI DO
                start pos +:= 1
            OD;
            IF end pos < start pos THEN "0" ELSE v[ start pos : end pos ] FI
         END # TOSTRING # ;

    # returns a string representation of the POINT p                         #
    OP   TOSTRING = ( POINT p )STRING: "( " + TOSTRING x OF p + ", " + TOSTRING y OF p + " )";

    # returns a string representation of the points of p                     #
    OP   TOSTRING = ( POLYGON p )STRING:
         BEGIN
            STRING result    := "(", separator := "";
            FOR i FROM LWB p TO UPB p DO
                result   +:= separator + " " + TOSTRING p[ i ];
                separator := ","
            OD;
            result + " )"
         END # TOSTRING # ;

    # code specific to thius task                                            #
    # test cases - using the general POLYGON MODE to represent triangles     #
    [,]POLYGON triangle pairs
        = ( ( ( ( 0, 0 ), ( 5, 0 ), (   0, 5 ) ), ( (  0, 0 ), (   5,  0 ), (  0, 6 ) ) )
          , ( ( ( 0, 0 ), ( 0, 5 ), (   5, 0 ) ), ( (  0, 0 ), (   0,  5 ), (  5, 0 ) ) )
          , ( ( ( 0, 0 ), ( 5, 0 ), (   0, 5 ) ), ( (-10, 0 ), (  -5,  0 ), ( -1, 6 ) ) )
          , ( ( ( 0, 0 ), ( 5, 0 ), ( 2.5, 5 ) ), ( (  0, 4 ), ( 2.5, -1 ), (  5, 4 ) ) )
          , ( ( ( 0, 0 ), ( 1, 1 ), (   0, 2 ) ), ( (  2, 1 ), (   3,  0 ), (  3, 2 ) ) )
          , ( ( ( 0, 0 ), ( 1, 1 ), (   0, 2 ) ), ( (  2, 1 ), (   3, -2 ), (  3, 4 ) ) )
          , ( ( ( 0, 0 ), ( 1, 0 ), (   0, 1 ) ), ( (  1, 0 ), (   2,  0 ), (  1, 1 ) ) )
          );
    FOR t pos FROM LWB triangle pairs TO UPB triangle pairs DO
        []POLYGON tpair = triangle pairs[ t pos, : ];
        POLYGON   t1    = tpair[ LWB tpair ];
        POLYGON   t2    = tpair[ UPB tpair ];
        print( ( TOSTRING t1
               , IF t1 OVERLAPS t2 THEN " overlaps " ELSE " does not overlap " FI
               , TOSTRING t2
               , newline
               )
             )
    OD
END
