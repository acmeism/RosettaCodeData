sub euler ( &f, $y0, $a, $b, $h ) {
    my $y = $y0;
    my @t_y;
    for $a, * + $h ... * > $b -> $t {
        @t_y[$t] = $y;
        $y += $h × f( $t, $y );
    }
    @t_y
}

constant COOLING_RATE = 0.07;
constant AMBIENT_TEMP =   20;
constant INITIAL_TEMP =  100;
constant INITIAL_TIME =    0;
constant FINAL_TIME   =  100;

sub f ( $time, $temp ) {
    -COOLING_RATE × ( $temp - AMBIENT_TEMP )
}

my @e;
@e[$_] = euler( &f, INITIAL_TEMP, INITIAL_TIME, FINAL_TIME, $_ ) for 2, 5, 10;

say 'Time Analytic   Step2   Step5  Step10     Err2     Err5    Err10';

for INITIAL_TIME, * + 10 ... * >= FINAL_TIME -> $t {

    my $exact = AMBIENT_TEMP + (INITIAL_TEMP - AMBIENT_TEMP)
                              × (-COOLING_RATE × $t).exp;

    my $err = sub { @^a.map: { 100 × ($_ - $exact).abs / $exact } }

    my ( $a, $b, $c ) = map { @e[$_][$t] }, 2, 5, 10;

    say $t.fmt('%4d '), ( $exact, $a, $b, $c )».fmt(' %7.3f'),
                            $err([$a, $b, $c])».fmt(' %7.3f%%');
}
