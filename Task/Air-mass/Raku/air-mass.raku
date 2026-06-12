constant DEG = pi/180;    # degrees to radians
constant RE  = 6371000;   # Earth radius in meters
constant dd  = 0.001;     # integrate in this fraction of the distance already covered
constant FIN = 10000000;  # integrate only to a height of 10000km, effectively infinity

#| Density of air as a function of height above sea level
sub rho ( \a ) { exp( -a / 8500 ) }

sub height ( \a, \z, \d ) {
    # a = altitude of observer
    # z = zenith angle (in degrees)
    # d = distance along line of sight
    my \AA = RE + a;
    sqrt( AA² + d² - 2*d*AA*cos((180-z)*DEG) ) - AA;
}

#| Integrates density along the line of sight
sub column_density ( \a, \z ) {
    my $sum = 0;
    my $d   = 0;
    while $d < FIN {
        my \delta = max(dd, (dd)*$d);  # Adaptive step size to avoid it taking forever
        $sum += rho(height(a, z, $d + delta/2))*delta;
        $d   += delta;
    }
    $sum;
}

sub airmass ( \a, \z ) {
    column_density( a, z ) /
    column_density( a, 0 )
}

say 'Angle     0 m              13700 m';
say '------------------------------------';
say join "\n", (0, 5 ... 90).hyper(:3batch).map: -> \z {
    sprintf "%2d      %11.8f      %11.8f", z, airmass(    0, z), airmass(13700, z);
}
