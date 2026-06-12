begin
    % returns the length of the arc between the angles a and b on a circle of radius r %
    % the angles should  be specified in degrees                                       %
    real procedure majorArcLength( real value a, b, r ) ;
    begin
        real angle;
        angle := abs( a - b );
        while angle > 360 do angle := angle - 360;
        if angle < 180 then angle := 360 - angle;
        ( r * angle * PI ) / 180
    end majorArcLength ;
    % task test case                                                                   %
    write( r_w := 10, r_d := 4, r_format := "A", majorArcLength( 10, 120, 10 ) )
end.
