sub euler ( &f, $y0, $a, $b, $h ) {
    my $y = $y0;
    my @t_y;
    for $a, * + $h ... * > $b -> $t {
        @t_y[$t] = $y;
        $y += $h * f( $t, $y );
    }
    return @t_y;
}

my $COOLING_RATE = 0.07;
my $AMBIENT_TEMP =   20;
my $INITIAL_TEMP =  100;
my $INITIAL_TIME =    0;
my $FINAL_TIME   =  100;

sub f ( $time, $temp ) {
    return -$COOLING_RATE * ( $temp - $AMBIENT_TEMP );
}

my @e;
@e[$_] = euler( &f, $INITIAL_TEMP, $INITIAL_TIME, $FINAL_TIME, $_ ) for 2, 5, 10;

say 'Time Analytic   Step2   Step5  Step10     Err2     Err5    Err10';

for $INITIAL_TIME, * + 10 ... * >= $FINAL_TIME -> $t {

    my $exact = $AMBIENT_TEMP + ($INITIAL_TEMP - $AMBIENT_TEMP)
                              * (-$COOLING_RATE * $t).exp;

    my $err = sub { @^a.map: { 100 * abs( $_ - $exact ) / $exact } }

    my ( $a, $b, $c ) = map { @e[$_][$t] }, 2, 5, 10;

    say $t.fmt('%4d '), ( $exact, $a, $b, $c )».fmt(' %7.3f'),
                           $err.([$a, $b, $c])».fmt(' %7.3f%%');
}
