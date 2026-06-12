BEGIN # construct a B-Spline                                                 #

    # mode to hold a B Spline                                                #
    MODE BSPLINE = STRUCT( FLEX[ 1 : 0, 1 : 2 ]INT control points
                         , INT n
                         , INT k
                         , FLEX[ 1 : 0 ]INT t
                         );
    PROC  uniform knot vector = ( INT lb, ub )[]INT:
          BEGIN
             [ lb : ub ]INT range;
             FOR n FROM lb TO ub DO range[ n ] := n OD;
             range
          END # uniform knot vector # ;

    PROC calculate bspline = ( REF BSPLINE cbs, INT cbi, cbk, cbx )REAL:
         IF   cbk = 1
         THEN ABS ( ( t OF cbs )[ cbi ] <= cbx AND cbx < ( t OF cbs )[ cbi + 1 ] )
         ELSE
              PROC helper = ( REF BSPLINE bs, INT i, k, x )REAL:
                   IF ( t OF bs )[ i + k ] /= ( t OF bs )[ i ]
                   THEN ( x - ( t OF bs )[ i ] ) / ( ( t OF bs )[ i + k ] - ( t OF bs )[ i ] )
                   ELSE 0
                   FI # helper # ;
              (     helper( cbs, cbi,     cbk - 1, cbx ) ) * calculate bspline( cbs, cbi,     cbk - 1, cbx )
            + ( 1 - helper( cbs, cbi + 1, cbk - 1, cbx ) ) * calculate bspline( cbs, cbi + 1, cbk - 1, cbx )
         FI # calculate bspline # ;

    PROC round = ( REAL n )INT: ENTIER( n + 0.5 );

    PROC get bspline points = ( REF BSPLINE bs )[,]INT:
         BEGIN
            INT p from = ( t OF bs )[     k OF bs ];
            INT p to   = ( t OF bs )[ 1 + n OF bs ] - 1;
            [ p from : p to, 1 : 2 ]INT points;
            FOR x FROM p from TO p to DO
                REAL sum x := 0;
                REAL sum y := 0;
                FOR i TO n OF bs DO
                    REAL f = calculate bspline( bs, i, k OF bs, x );
                    sum x +:= f * ( control points OF bs )[ i, 1 ];
                    sum y +:= f * ( control points OF bs )[ i, 2 ]
                OD;
                points[ x, 1 ] := round( sum x );
                points[ x, 2 ] := round( sum y )
            OD;
            points
         END # get bspline points # ;

    PROC raytrace = ( INT x0, y0, x2, y2, REF[,]BOOL rtplot, PROC( REF[,]BOOL, INT, INT )VOID visit )VOID:
         BEGIN
            INT x    := x0;
            INT y    := y0;
            INT dx   := ABS ( x2 - x );
            INT dy   := ABS ( y2 - y );
            INT n     = 1 + dx + dy;
            INT dir x = IF x2 > x THEN 1 ELSE -1 FI;
            INT dir y = IF y2 > y THEN 1 ELSE -1 FI;
            INT err  := dx - dy;
            dx *:= 2;
            dy *:= 2;
            TO n DO
                visit( rtplot, x, y );
                IF   err > 0
                THEN x +:= dir x; err -:= dy
                ELSE y +:= dir y; err +:= dx
                FI
            OD
         END # raytrace # ;

    PROC plot line = ( REF[,]BOOL plplot, INT x1, y1, x2, y2 )VOID:
         raytrace( x1, y1, x2, y2, plplot
                 , ( REF[,]BOOL plot, INT x, INT y )VOID: IF   x >= 0
                                                          AND  y >= 0
                                                          AND  x < 1 UPB plot
                                                          AND  y < 2 UPB plot
                                                          THEN plot[ x + 1, y + 1 ] := TRUE
                                                          FI
                );

    PROC plot bspline = ( REF BSPLINE bs, REF[,]BOOL bsplot, REAL scale x, scale y )VOID:
         IF k OF bs > n OF bs OR k OF bs < 1 THEN
            print( ( "k (= ", whole( k OF bs, 0 ), ") can't be more than ", whole( n OF bs, 0 ) ) );
            print( ( " or less than 1.", newline ) );
            stop
         ELSE
            [,]INT points = get bspline points( bs );
            # Plot the curve. #
            FOR i FROM 1 LWB points TO 1 UPB points - 1 DO
                INT p1x = points[ i,     1 ], p1y = points[ i,     2 ];
                INT p2x = points[ i + 1, 1 ], p2y = points[ i + 1, 2 ];
                plot line( bsplot
                         , round( p1x * scale x ), round( p1y * scale y )
                         , round( p2x * scale x ), round( p2y * scale y )
                         )
            OD
         FI # plot bspline # ;

    # print the plot - outputs @ or blank depending on whether the point is plotted or not #
    PROC print plot = ( [,]BOOL plot )VOID:
         FOR row FROM 1 LWB plot
         TO BEGIN # find the highest used row #
                INT max row := 1 UPB plot;
                WHILE IF max row < 1 LWB plot
                      THEN FALSE
                      ELSE
                          BOOL empty row := TRUE;
                          FOR column FROM 2 LWB plot TO 2 UPB plot
                          WHILE empty row := NOT plot[ column, max row ]
                          DO
                              SKIP
                          OD;
                          empty row
                      FI
                DO
                    max row -:= 1
                OD;
                max row
            END
         DO
             INT max column := 2 UPB plot;
             WHILE IF max column < 2 LWB plot THEN FALSE ELSE NOT plot[ max column, row ] FI
             DO
                 max column -:= 1
             OD;
             FOR column FROM 2 LWB plot TO max column DO
                 print( ( IF plot[ column, row ] THEN "@" ELSE " " FI ) )
             OD;
             print( ( newline ) )
         OD # print plot # ;

    BEGIN # task #
        [,]INT  control points
             =   ( ( 171, 171 ), ( 185, 111 ), ( 202, 109 ), ( 202, 189 ), ( 328, 160 ), ( 208, 254 )
                 , ( 241, 330 ), ( 164, 252 ), (  69, 278 ), ( 139, 208 ), (  72, 148 ), ( 168, 172 )
                 );
        INT     k = 4;  # Polynomial degree is one less than this i.e. cubic. #
        BSPLINE bs := ( control points
                      , UPB control points
                      , k
                      , uniform knot vector( 1, UPB control points + k )
                      );

        REAL scale x = 0.4; # Since we print the plot to the console as text let's scale things appropriately. #
        REAL scale y = 0.2;
        [ 1 : 350, 1 : 350 ]BOOL plot;
        FOR r FROM 1 LWB plot TO 1 UPB plot DO
            FOR c FROM 2 LWB plot TO 2 UPB plot DO plot[ c, r ] := FALSE OD
        OD;
        plot bspline( bs, plot, scale x, scale y );
        print plot( plot )
    END
END
