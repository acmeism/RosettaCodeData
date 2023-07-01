begin % compute the distance between places using the Haversine formula %
    real procedure arcsin( real value x ) ; arctan( x / sqrt( 1 - ( x * x ) ) );
    real procedure distance ( real value th1Deg, ph1Deg, th2Deg, ph2Deg ) ;
    begin
        real ph1, th1, th2, toRad, dz, dx, dy;
        toRad := pi / 180;
        ph1   := ( ph1Deg - ph2Deg ) * toRad;
        th1   := th1Deg * toRad;
        th2   := th2Deg * toRad;
        dz    := sin( th1 ) - sin( th2 );
        dx    := cos( ph1 ) * cos( th1 ) - cos( th2 );
        dy    := sin( ph1 ) * cos( th1 );
        arcsin( sqrt( dx * dx + dy * dy + dz * dz ) / 2 ) * 2 * 6371
    end distance ;
    begin
        real d;
        integer mi, km;
        d  := distance( 36.12, -86.67, 33.94, -118.4 );
        mi := round( d );
        km := round( d / 1.609344 );
        writeon( i_w := 4, s_w := 0, "distance: ", mi, " km (", km, " mi.)" )
    end
end.
