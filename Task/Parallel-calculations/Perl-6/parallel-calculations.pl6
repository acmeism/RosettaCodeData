my @nums = 64921987050997300559,  70251412046988563035,  71774104902986066597,
           83448083465633593921,  84209429893632345702,  87001033462961102237,
           87762379890959854011,  89538854889623608177,  98421229882942378967,
           259826672618677756753, 262872058330672763871, 267440136898665274575,
           278352769033314050117, 281398154745309057242, 292057004737291582187;

my \factories = @nums.hyper.map: *.&prime-factors.cache;
say my $gmf = {}.append(factories»[0] »=>« @nums).max: {+.key};

sub prime-factors ( Int $n where * > 0 ) {
    return $n if $n.is-prime;
    return [] if $n == 1;
    my $factor = find-factor( $n );
    sort flat prime-factors( $factor ), prime-factors( $n div $factor );
}

sub find-factor ( Int $n, $constant = 1 ) {
    my $x      = 2;
    my $rho    = 1;
    my $factor = 1;
    while $factor == 1 {
        $rho *= 2;
        my $fixed = $x;
        for ^$rho {
            $x = ( $x * $x + $constant ) % $n;
            $factor = ( $x - $fixed ) gcd $n;
            last if 1 < $factor;
        }
    }
    $factor = find-factor( $n, $constant + 1 ) if $n == $factor;
    $factor;
}
