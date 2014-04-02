sub inverse($n, :$modulo) {
    my ($c, $d, $uc, $vc, $ud, $vd) = ($n % $modulo, $modulo, 1, 0, 0, 1);
    my $q;
    while $c != 0 {
        ($q, $c, $d) = ($d div $c, $d % $c, $c);
        ($uc, $vc, $ud, $vd) = ($ud - $q*$uc, $vd - $q*$vc, $uc, $vc);
    }
    return $ud % $modulo;
}

say inverse 42, :modulo(2017)
