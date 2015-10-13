sub horner ( @coeffs, $x ) {
    ([o] map { $_ + $x * * }, @coeffs)(0);
}

say horner( [ -19, 7, -4, 6 ], 3 );
