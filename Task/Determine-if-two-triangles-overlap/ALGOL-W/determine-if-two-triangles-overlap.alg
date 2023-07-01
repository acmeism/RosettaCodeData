begin % determine if two triangles overlap %
    record Point    ( real x, y );
    record Triangle ( reference(Point) p1, p2, p3 );
    procedure WritePoint ( reference(Point) value p ) ;
        writeon( r_w := 3, r_d := 1, r_format := "A", s_w := 0, "(", x(p), ", ", y(p), ")" );
    procedure WriteTriangle ( reference(Triangle) value t ) ;
    begin
        WritePoint( p1(t) );
        writeon( ", " );
        WritePoint( p2(t) );
        writeon( ", " );
        WritePoint( p3(t) )
    end WriteTriangle ;
    real procedure Det2D ( reference(Triangle) value t ) ;
        ( ( x(p1(t)) * ( y(p2(t)) - y(p3(t)) ) )
        + ( x(p2(t)) * ( y(p3(t)) - y(p1(t)) ) )
        + ( x(p3(t)) * ( y(p1(t)) - y(p2(t)) ) )
        );
    procedure CheckTriWinding ( reference(Triangle) value t ; logical value allowReversed ) ;
    begin
        real detTri;
        detTri := Det2D(t);
        if detTri < 0.0 then begin
            if allowReversed then begin
                reference(Point) a;
                a     := p3(t);
                p3(t) := p2(t);
                p2(t) := a
                end
            else begin
                write( "triangle has wrong winding direction" );
                assert( false )
            end
        end if_detTri_lt_0
    end CheckTriWinding ;
    logical procedure BoundaryCollideChk(       reference(Triangle) value t ; real value eps ) ; Det2D( t ) <  eps ;
    logical procedure BoundaryDoesntCollideChk( reference(Triangle) value t ; real value eps ) ; Det2D( t ) <= eps ;
    logical procedure TriTri2D( reference(Triangle) value t1, t2 ; real value eps ; logical value allowReversed, onBoundary ) ;
    begin
        logical procedure ChkEdge( reference(Triangle) value t ) ;
                if onBoundary then % Points on the boundary are considered as colliding %
                                   BoundaryCollideChk(       t, eps )
                              else % Points on the boundary are not considered as colliding %
                                   BoundaryDoesntCollideChk( t, eps )
                              ;
        reference(Point) array lp1, lp2 ( 0 :: 2 );
        logical                overlap;
        overlap := true;
        % Triangles must be expressed anti-clockwise %
        CheckTriWinding( t1, allowReversed );
        CheckTriWinding( t2, allowReversed );
        lp1( 0 ) := p1(t1); lp1( 1 ) := p2(t1); lp1( 2 ) := p3(t1);
        lp2( 0 ) := p1(t2); lp2( 1 ) := p2(t2); lp2( 2 ) := p3(t2);
        % for each edge E of t1 %
        for i := 0 until 2 do begin
            integer j;
            j := ( i + 1 ) rem 3;
            % Check all points of t2 lay on the external side of edge E. %
            % if they do, the triangles do not overlap.                  %
            if  ChkEdge( Triangle( lp1( i ), lp1( j ), lp2( 0 ) ) )
            and ChkEdge( Triangle( lp1( i ), lp1( j ), lp2( 1 ) ) )
            and ChkEdge( Triangle( lp1( i ), lp1( j ), lp2( 2 ) ) )
            then begin
                overlap := false;
                goto return
            end
        end for_i ;
        % for each edge E of t2 %
        for i := 0 until 2 do begin
            integer j;
            j := ( i + 1 ) rem 3;
            % Check all points of t1 lay on the external side of edge E. %
            % if they do, the triangles do not overlap.                  %
            if  ChkEdge( Triangle( lp2( i ), lp2( j ), lp1( 0 ) ) )
            and ChkEdge( Triangle( lp2( i ), lp2( j ), lp1( 1 ) ) )
            and ChkEdge( Triangle( lp2( i ), lp2( j ), lp1( 2 ) ) )
            then begin
                overlap := false;
                goto return
            end
        end for_i;
        % if we get here, The triangles overlap %
return: overlap
    end TriTri2D ;
    procedure CheckOverlap( reference(Triangle) value t1, t2
                          ; real                value eps
                          ; logical             value allowReversed, onBoundary
                          ) ;
    begin
        write( "Triangles " );
        WriteTriangle( t1 );
        writeon( " and " );
        WriteTriangle( t2 );
        writeon( if TriTri2D( t1, t2, eps, allowReversed, onBoundary ) then " overlap" else " do not overlap" );
    end CheckOverlap ;
    begin % main %
        reference(Triangle) t1, t2;
        t1 := Triangle( Point( 0.0, 0.0 ), Point( 5.0, 0.0 ), Point( 0.0, 5.0 ) );
        t2 := Triangle( Point( 0.0, 0.0 ), Point( 5.0, 0.0 ), Point( 0.0, 6.0 ) );
        CheckOverlap( t1, t2, 0.0, false, true );
        t1 := Triangle( Point( 0.0, 0.0 ), Point( 0.0, 5.0 ), Point( 5.0, 0.0 ) );
        t2 := Triangle( Point( 0.0, 0.0 ), Point( 0.0, 5.0 ), Point( 5.0, 0.0 ) );
        CheckOverlap(t1, t2, 0.0, true, true );
        t1 := Triangle( Point(   0.0, 0.0 ), Point(  5.0, 0.0 ), Point(  0.0, 5.0 ) );
        t2 := Triangle( Point( -10.0, 0.0 ), Point( -5.0, 0.0 ), Point( -1.0, 6.0 ) );
        CheckOverlap( t1, t2, 0.0, false, true );
        t1 := Triangle( Point( 0.0, 0.0 ), Point( 5.0,  0.0 ), Point( 2.5, 5.0 ) );
        t2 := Triangle( Point( 0.0, 4.0 ), Point( 2.5, -1.0 ), Point( 5.0, 4.0 ) );
        CheckOverlap( t1, t2, 0.0, false, true );
        t1 := Triangle( Point( 0.0, 0.0 ), Point( 1.0, 1.0 ), Point( 0.0, 2.0 ) );
        t2 := Triangle( Point( 2.0, 1.0 ), Point( 3.0, 0.0 ), Point( 3.0, 2.0 ) );
        CheckOverlap( t1, t2, 0.0, false, true );
        t1 := Triangle( Point( 0.0, 0.0 ), Point( 1.0,  1.0 ), Point( 0.0, 2.0 ) );
        t2 := Triangle( Point( 2.0, 1.0 ), Point( 3.0, -2.0 ), Point( 3.0, 4.0 ) );
        CheckOverlap( t1, t2, 0.0, false, true );
        t1 := Triangle( Point( 0.0, 0.0 ), Point( 1.0, 0.0 ), Point( 0.0, 1.0 ) );
        t2 := Triangle( Point( 1.0, 0.0 ), Point( 2.0, 0.0 ), Point( 1.0, 1.1 ) );
        CheckOverlap( t1, t2, 0.0, false, true );
        t1 := Triangle( Point( 0.0, 0.0 ), Point( 1.0, 0.0 ), Point( 0.0, 1.0 ) );
        t2 := Triangle( Point( 1.0, 0.0 ), Point( 2.0, 0.0 ), Point( 1.0, 1.1 ) );
        CheckOverlap( t1, t2, 0.0, false, false );
    end
end.
