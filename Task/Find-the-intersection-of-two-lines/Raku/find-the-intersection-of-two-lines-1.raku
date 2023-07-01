sub intersection (Real $ax, Real $ay, Real $bx, Real $by,
                  Real $cx, Real $cy, Real $dx, Real $dy ) {

    sub term:<|AB|> { determinate($ax, $ay, $bx, $by) }
    sub term:<|CD|> { determinate($cx, $cy, $dx, $dy) }

    my $ΔxAB = $ax - $bx;
    my $ΔyAB = $ay - $by;
    my $ΔxCD = $cx - $dx;
    my $ΔyCD = $cy - $dy;

    my $x-numerator = determinate( |AB|, $ΔxAB, |CD|, $ΔxCD );
    my $y-numerator = determinate( |AB|, $ΔyAB, |CD|, $ΔyCD );
    my $denominator = determinate( $ΔxAB, $ΔyAB, $ΔxCD, $ΔyCD );

    return 'Lines are parallel' if $denominator == 0;

    ($x-numerator/$denominator, $y-numerator/$denominator);
}

sub determinate ( Real $a, Real $b, Real $c, Real $d ) { $a * $d - $b * $c }

# TESTING
say 'Intersection point: ', intersection( 4,0, 6,10, 0,3, 10,7 );
say 'Intersection point: ', intersection( 4,0, 6,10, 0,3, 10,7.1 );
say 'Intersection point: ', intersection( 0,0, 1,1, 1,2, 4,5 );
