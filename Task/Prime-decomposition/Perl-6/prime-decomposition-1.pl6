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

for 2²⁹-1, 2⁴¹-1, 2⁵⁹-1, 2⁷¹-1, 2⁷⁹-1, 2⁹⁷-1, 2¹¹⁷-1,
5465610891074107968111136514192945634873647594456118359804135903459867604844945580205745718497
 ->  $n {
    my $start = now;
    say "factors of $n: ",
    prime-factors($n).join(' × '), " \t in ", (now - $start).fmt("%0.3f"), " sec."
}
