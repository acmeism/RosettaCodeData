sub prime-factors ( Int $n where * > 0 ) {
    return $n if $n.is-prime;
    return () if $n == 1;
    my $factor = find-factor( $n );
    sort flat ( $factor, $n div $factor ).map: &prime-factors;
}

sub find-factor ( Int $n, $constant = 1 ) {
    return 2 unless $n +& 1;
    if (my $gcd = $n gcd 6541380665835015) > 1 { # magic number: [*] primes 3 .. 43
        return $gcd if $gcd != $n
    }
    my $x      = 2;
    my $rho    = 1;
    my $factor = 1;
    while $factor == 1 {
        $rho = $rho +< 1;
        my $fixed = $x;
        my int $i = 0;
        while $i < $rho {
            $x = ( $x * $x + $constant ) % $n;
            $factor = ( $x - $fixed ) gcd $n;
            last if 1 < $factor;
            $i = $i + 1;
        }
    }
    $factor = find-factor( $n, $constant + 1 ) if $n == $factor;
    $factor;
}

.put for (125, 217, 4294967213, 9759463979, 34225158206557151, 763218146048580636353,
5465610891074107968111136514192945634873647594456118359804135903459867604844945580205745718497)\
.hyper(:1batch).map: -> $n {
    my $start = now;
   "factors of $n: ({1+$n.msb} bits) ",
    prime-factors($n).join(' × '), " \t in ", (now - $start).fmt("%0.3f"), " sec."
}
