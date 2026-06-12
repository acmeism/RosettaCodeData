begin % find the centroid of some N dimensional points                       %

    % sets cPoints to the centroid of points                                 %
    procedure centroid( real array points ( *, * )
                      ; integer value numberOfPoints, dimension
                      ; real array cPoint ( * )
                      ) ;
    for j := 1 until dimension do begin
        real sum;
        sum := 0;
        for i := 1 until numberOfpoints do sum := sum + points( i, j );
        cPoint( j ) := sum / numberOfPoints
    end centroid ;

    begin % task test cases                                                  %

        % show a real number with two decimal places if if is not integral   %
        procedure show ( real value rValue ) ;
        begin
            integer iValue;
            iValue := truncate( rValue );
            if iValue = rValue then writeon( s_w := 0, i_w := 1, " ", iValue )
                               else writeon( s_w := 0
                                           , r_format := "A", r_w := 4, r_d := 2
                                           , " ", rValue
                                           )
        end show ;

        procedure testCentroid( real array points ( *, * )
                              ; integer value numberOfPoints, dimension
                              ) ;
        begin
            real array cPoint( 1 :: dimension );
            centroid( points, numberOfPoints, dimension, cPoint );
            write( "[" );
            for i := 1 until numberOfPoints do begin
                writeon( "[" );
                for j := 1 until dimension do show( points( i, j ) );
                writeon( " ]" );
            end for_i ;
            writeon( "] -> [" );
            for j := 1 until dimension do show( cPoint( j ) );
            writeon( " ]" )
        end testCentroid ;

        real array p1 ( 1 :: 3, 1 :: 1 ); real array p2 ( 1 :: 2, 1 :: 2 );
        real array p3 ( 1 :: 2, 1 :: 3 ); real array p4 ( 1 :: 4, 1 :: 3 );
        real array p5 ( 1 :: 4, 1 :: 5 );

        p1( 1, 1 ) :=  1;  p1( 2, 1 ) :=   2; p1( 3, 1 ) := 3;
        p2( 1, 1 ) :=  8;  p2( 1, 2 ) :=   2;
        p2( 2, 1 ) :=  0;  p2( 2, 2 ) :=   0;
        p3( 1, 1 ) :=  5;  p3( 1, 2 ) :=   5; p3( 1, 3 ) := 0;
        p3( 2, 1 ) := 10;  p3( 2, 2 ) :=  10; p3( 2, 3 ) := 0;
        p4( 1, 1 ) :=  1;  p4( 1, 2 ) := 3.1; p4( 1, 3 ) := 6.5;
        p4( 2, 1 ) := -2;  p4( 2, 2 ) :=  -5; p4( 2, 3 ) := 3.4;
        p4( 3, 1 ) := -7;  p4( 3, 2 ) :=  -4; p4( 3, 3 ) := 9;
        p4( 4, 1 ) :=  2;  p4( 4, 2 ) :=   0; p4( 4, 3 ) := 3;
        p5( 1, 1 ) :=  0;  p5( 1, 2 ) :=   0; p5( 1, 3 ) := 0;  p5( 1, 4 ) := 0;  p5( 1, 5 ) := 1;
        p5( 2, 1 ) :=  0;  p5( 2, 2 ) :=   0; p5( 2, 3 ) := 0;  p5( 2, 4 ) := 1;  p5( 2, 5 ) := 0;
        p5( 3, 1 ) :=  0;  p5( 3, 2 ) :=   0; p5( 3, 3 ) := 1;  p5( 3, 4 ) := 0;  p5( 3, 5 ) := 0;
        p5( 4, 1 ) :=  0;  p5( 4, 2 ) :=   1; p5( 4, 3 ) := 0;  p5( 4, 4 ) := 0;  p5( 4, 5 ) := 0;

        testCentroid( p1, 3, 1 );
        testCentroid( p2, 2, 2 );
        testCentroid( p3, 2, 3 );
        testCentroid( p4, 4, 3 );
        testCentroid( p5, 4, 5 )

    end

end.
