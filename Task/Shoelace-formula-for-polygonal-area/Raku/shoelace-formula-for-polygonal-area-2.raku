sub area-by-shoelace ( @p ) {
    my @x := @p».[0];
    my @y := @p».[1];

    my $s := ( @x Z* @y.rotate( 1) ).sum
           - ( @x Z* @y.rotate(-1) ).sum;

    return $s.abs / 2;
}

say area-by-shoelace( [ (3,4), (5,11), (12,8), (9,5), (5,6) ] );
