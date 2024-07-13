begin % find the intersection of two lines                                   %

    record Point ( real x, y );
    record Line  ( real m, c );                                 % y = mx + c %

    % returns the line that passes through p1 and p2                         %
    reference(Line) procedure findLine ( reference(Point) value p1, p2 ) ;
        if x(p1) = x(p2) then begin                  % the line is verticval %
            Line( 0, x(p1) )
            end
        else begin                                % the line is not vertical %
            real m1;
            m1 := ( y(p1) - y(p2) ) / ( x(p1) - x(p2) );
            Line( m1, y(p1) - ( m1 * x(p1) ) )
        end findLine ;

    % returns the intersection of two lines                                  %
    %       - the lines must be distinct and not parallel                    %
    reference(Point) procedure intersection ( reference(Line) value l1, l2 ) ;
        begin
            real x;
            x := ( c(l2) - c(l1) ) / ( m(l1) - m(l2) );
            Point( x, ( m(l1) * x ) + c(l1) )
        end intersection ;

    begin % find the intersection of the lines as per the task               %
        reference(Point) i;
        i := intersection( findLine( Point( 4.0, 0.0 ), Point(  6.0, 10.0 ) )
                         , findLine( Point( 0.0, 3.0 ), Point( 10.0,  7.0 ) )
                         );
        write( r_format := "A", r_w := 8, r_d := 4, x(i), y(i) )
    end
end.
