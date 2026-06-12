# Simple Vector implementation
multi infix:<+>(@a, @b) { @a Z+ @b }
multi infix:<->(@a, @b) { @a Z- @b }
multi infix:<*>($r, @a) { $r X* @a }
multi infix:</>(@a, $r) { @a X/ $r }
sub norm { sqrt [+] @_ X** 2 }

# Runge-Kutta stuff
sub runge-kutta(&yp) {
    return -> \t, \y, \δt {
        my $a = δt * yp( t, y );
        my $b = δt * yp( t + δt/2, y + $a/2 );
        my $c = δt * yp( t + δt/2, y + $b/2 );
        my $d = δt * yp( t + δt, y + $c );
        ($a + 2*($b + $c) + $d) / 6;
    }
}

# gravitational constant
constant G = 6.674e-11;
# astronomical unit
constant au = 150e9;

# time constants in seconds
constant year = 365.25*24*60*60;
constant month = 21*24*60*60;

# masses in kg
constant $ma = 2e30;     # Sun
constant $mb = 6e24;     # Earth
constant $mc = 7.34e22;  # Moon

my &dABC = runge-kutta my &f = sub ( $t, @ABC ) {
    my @a = @ABC[0..2];
    my @b = @ABC[3..5];
    my @c = @ABC[6..8];

    my $ab = norm(@a - @b);
    my $ac = norm(@a - @c);
    my $bc = norm(@b - @c);

    return [
        flat
        @ABC[@(9..17)],
        map G * *,
        $mb/$ab**3 * (@b - @a) + $mc/$ac**3 * (@c - @a),
        $ma/$ab**3 * (@a - @b) + $mc/$bc**3 * (@c - @b),
        $ma/$ac**3 * (@a - @c) + $mb/$bc**3 * (@b - @c);
    ];
}

loop (
    my ($t, @ABC) = 0,
        0, 0, 0,                                 # Sun position
        au, 0, 0,                                # Earth position
        0.998*au, 0, 0,                          # Moon position
        0, 0, 0,                                 # Sun speed
        0, 2*pi*au/year, 0,                      # Earth speed
        0, 2*pi*(au/year + 0.002*au/month), 0    # Moon speed
    ;
    $t < .2;
    ($t, @ABC) »+=« (.01, dABC($t, @ABC, .01))
) {
    printf "t = %.02f : %s\n", $t, @ABC.fmt("%+.3e");
}
