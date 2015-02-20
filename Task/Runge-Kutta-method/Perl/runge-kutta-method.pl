sub runge_kutta {
    my ($yp, $dt) = @_;
    sub {
	my ($t, $y) = @_;
	my @dy =  $dt * $yp->( $t        , $y );
	push @dy, $dt * $yp->( $t + $dt/2, $y + $dy[0]/2 );
	push @dy, $dt * $yp->( $t + $dt/2, $y + $dy[1]/2 );
	push @dy, $dt * $yp->( $t + $dt  , $y + $dy[2] );
	return $t + $dt, $y + ($dy[0] + 2*$dy[1] + 2*$dy[2] + $dy[3]) / 6;
    }
}

my $RK = runge_kutta sub { $_[0] * sqrt $_[1] }, .1;

for(
    my ($t, $y) = (0, 1);
    sprintf("%.0f", $t) <= 10;
    ($t, $y) = $RK->($t, $y)
) {
    printf "y(%2.0f) = %12f ± %e\n", $t, $y, abs($y - ($t**2 + 4)**2 / 16)
    if sprintf("%.4f", $t) =~ /0000$/;
}
