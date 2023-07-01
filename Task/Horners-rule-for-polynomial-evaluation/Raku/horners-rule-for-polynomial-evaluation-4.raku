sub horner ( @coeffs, $x ) {
    map { .(0) }, [\o] map { $_ + $x * * }, @coeffs;
}

say horner( [ 1 X/ (1, |[\*] 1 .. *) ], i*pi )[20];
